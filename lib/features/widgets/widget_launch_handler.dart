import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../dice/presentation/widgets/floating_dice_fab.dart';
import '../dice/providers/dice_drawer_provider.dart';

enum WidgetLaunchDestination { character, dice, unknown }

class WidgetLaunchEvent {
  final WidgetLaunchDestination destination;
  final String? characterId;

  const WidgetLaunchEvent({required this.destination, this.characterId});

  static WidgetLaunchEvent? parse(Uri? uri) {
    if (uri == null) return null;

    // Handle custom scheme: scrivener://dice or scrivener://character?id=...
    if (uri.scheme == 'scrivener') {
      final host = uri.host.toLowerCase();
      final path = uri.path.replaceAll('/', '').toLowerCase();

      if (host == 'dice' || path == 'dice') {
        return const WidgetLaunchEvent(
          destination: WidgetLaunchDestination.dice,
        );
      }

      if (host == 'character' || path.startsWith('character')) {
        String? id = uri.queryParameters['id'];
        if (id == null || id.isEmpty) {
          if (host == 'character' && uri.pathSegments.isNotEmpty) {
            id = uri.pathSegments.first;
          } else if (uri.pathSegments.length > 1) {
            id = uri.pathSegments[1];
          }
        }
        if (id != null && id.isNotEmpty) {
          return WidgetLaunchEvent(
            destination: WidgetLaunchDestination.character,
            characterId: id,
          );
        }
      }
    }

    // Support query parameter fallback (demo URLs / intent extras)
    if (uri.queryParameters['openDice'] == 'true') {
      return const WidgetLaunchEvent(destination: WidgetLaunchDestination.dice);
    }

    final charId = uri.queryParameters['char'];
    if (charId != null && charId.isNotEmpty) {
      return WidgetLaunchEvent(
        destination: WidgetLaunchDestination.character,
        characterId: charId,
      );
    }

    return null;
  }
}

/// Controller responsible for listening to home screen widget tap events and navigating.
class WidgetLaunchController {
  static const MethodChannel _launchChannel = MethodChannel(
    'com.tollitech.scrivener/widget_launch',
  );

  /// Whether home screen widget integration is supported on the current platform.
  /// Android and iOS are supported; Linux, Windows, and Web are not.
  static bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  /// Whether the custom Android native launch channel is supported.
  static bool get isLaunchChannelSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  StreamSubscription<Uri?>? _subscription;
  String? _lastDispatchedUri;
  DateTime? _lastDispatchedTime;

  void initialize({
    required BuildContext context,
    required WidgetRef ref,
    required void Function(String characterId) onOpenCharacter,
  }) {
    if (!isSupported) return;

    // 1. Direct native MethodChannel for cold-start and warm-start intents (Android only)
    if (isLaunchChannelSupported) {
      _launchChannel.setMethodCallHandler((call) async {
        if (call.method == 'onWidgetLaunch') {
          final rawUri = call.arguments as String?;
          final uri = rawUri != null ? Uri.tryParse(rawUri) : null;
          if (uri != null && context.mounted) {
            _dispatch(uri, context, ref, onOpenCharacter);
          }
        }
      });

      _launchChannel
          .invokeMethod<String>('getInitialLaunchUri')
          .then((String? rawUri) {
            final uri = rawUri != null ? Uri.tryParse(rawUri) : null;
            if (uri != null && context.mounted) {
              _dispatch(uri, context, ref, onOpenCharacter);
            }
          })
          .catchError((e) {
            if (e is! MissingPluginException) {
              debugPrint('getInitialLaunchUri error: $e');
            }
          });
    }

    // 2. Fallback: HomeWidget plugin cold-start and warm-start listeners
    HomeWidget.initiallyLaunchedFromHomeWidget()
        .then((Uri? uri) {
          if (uri != null && context.mounted) {
            _dispatch(uri, context, ref, onOpenCharacter);
          }
        })
        .catchError((e) {
          if (e is! MissingPluginException) {
            debugPrint('initiallyLaunchedFromHomeWidget error: $e');
          }
        });

    _subscription?.cancel();
    try {
      _subscription = HomeWidget.widgetClicked.listen(
        (Uri? uri) {
          if (uri != null && context.mounted) {
            _dispatch(uri, context, ref, onOpenCharacter);
          }
        },
        onError: (e) {
          if (e is! MissingPluginException) {
            debugPrint('HomeWidget.widgetClicked error: $e');
          }
        },
      );
    } on MissingPluginException {
      // Platform does not support home_widget stream.
    } catch (e) {
      debugPrint('HomeWidget.widgetClicked stream error: $e');
    }
  }

  void _dispatch(
    Uri uri,
    BuildContext context,
    WidgetRef ref,
    void Function(String characterId) onOpenCharacter,
  ) {
    final event = WidgetLaunchEvent.parse(uri);
    if (event == null) return;

    final now = DateTime.now();
    final uriStr = uri.toString();
    if (_lastDispatchedUri == uriStr &&
        _lastDispatchedTime != null &&
        now.difference(_lastDispatchedTime!).inMilliseconds < 500) {
      return;
    }
    _lastDispatchedUri = uriStr;
    _lastDispatchedTime = now;

    switch (event.destination) {
      case WidgetLaunchDestination.dice:
        ref.read(diceDrawerProvider.notifier).setQuickRoll();
        Navigator.of(context).popUntil((route) => route.isFirst);
        FloatingDiceFab.openFullScreenDiceRoller(context);
        break;
      case WidgetLaunchDestination.character:
        if (event.characterId != null) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          onOpenCharacter(event.characterId!);
        }
        break;
      case WidgetLaunchDestination.unknown:
        break;
    }
  }

  void dispose() {
    _launchChannel.setMethodCallHandler(null);
    _subscription?.cancel();
    _subscription = null;
  }
}
