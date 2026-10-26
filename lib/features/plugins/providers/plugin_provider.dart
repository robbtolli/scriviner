import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../models/plugin_manifest.dart';
import '../services/plugin_loader_service.dart';

class PluginState {
  final List<PluginManifest> installedPlugins;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const PluginState({
    this.installedPlugins = const [],
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  PluginState copyWith({
    List<PluginManifest>? installedPlugins,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return PluginState(
      installedPlugins: installedPlugins ?? this.installedPlugins,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}

class PluginNotifier extends Notifier<PluginState> {
  late final PluginLoaderService _service;

  @override
  PluginState build() {
    _service = PluginLoaderService();
    return const PluginState();
  }

  bool isInstalled(String pluginId) => _service.isPluginInstalled(pluginId);

  Future<bool> installManifest(PluginManifest manifest) async {
    state = state.copyWith(isLoading: true, clearMessages: true);
    try {
      final db = ref.read(databaseProvider);
      final count = await _service.installPlugin(db, manifest);
      state = state.copyWith(
        isLoading: false,
        installedPlugins: _service.installedPlugins,
        successMessage: 'Installed "${manifest.name}" ($count entries added)',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to install plugin: $e',
      );
      return false;
    }
  }

  Future<bool> installFromJson(String rawJson) async {
    try {
      final manifest = PluginManifest.parse(rawJson);
      return await installManifest(manifest);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Invalid plugin format: $e',
        clearMessages: true,
      );
      return false;
    }
  }

  Future<bool> uninstall(String pluginId) async {
    state = state.copyWith(isLoading: true, clearMessages: true);
    try {
      final db = ref.read(databaseProvider);
      final count = await _service.uninstallPlugin(db, pluginId);
      state = state.copyWith(
        isLoading: false,
        installedPlugins: _service.installedPlugins,
        successMessage: 'Uninstalled plugin ($count entries removed)',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to uninstall plugin: $e',
      );
      return false;
    }
  }

  Future<bool> installSamplePack() async {
    return await installManifest(PluginLoaderService.sampleEloriaPlugin);
  }

  void clearMessage() {
    state = state.copyWith(clearMessages: true);
  }
}

final pluginProvider = NotifierProvider<PluginNotifier, PluginState>(
  PluginNotifier.new,
);
