import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Branded title and loading screen shown briefly before revealing [child].
class AppSplashScreen extends StatefulWidget {
  final String title;
  final String logoAsset;
  final Widget child;
  final Duration duration;

  const AppSplashScreen({
    super.key,
    required this.title,
    required this.logoAsset,
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
  });

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _completed = true);
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_completed) {
      return widget.child;
    }

    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  widget.logoAsset,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    textStyle: theme.textTheme.headlineMedium,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: textColor,
                  ).copyWith(fontFamilyFallback: const ['serif']),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 140,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _controller.value,
                          minHeight: 4,
                          color: accentColor,
                          backgroundColor: accentColor.withValues(alpha: 0.18),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
