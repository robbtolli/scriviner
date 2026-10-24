import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class EmptyHomeState extends StatelessWidget {
  final VoidCallback onCreateNew;
  final VoidCallback onLoadSamples;

  const EmptyHomeState({
    super.key,
    required this.onCreateNew,
    required this.onLoadSamples,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryGold.withAlpha(120), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGold.withAlpha(40),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_stories,
                size: 64,
                color: AppTheme.primaryGold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your Chronicle Begins Here',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Text(
                'No characters found. Create your own custom hero with our beginner-friendly Guided Wizard, or load pre-made sample heroes to start exploring.',
                style: TextStyle(
                  color: Colors.white.withAlpha(190),
                  fontSize: 15,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onCreateNew,
                  icon: const Icon(Icons.add),
                  label: const Text('CREATE NEW CHARACTER'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onLoadSamples,
                  icon: const Icon(Icons.download),
                  label: const Text('LOAD SAMPLE HEROES'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
