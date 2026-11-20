import 'package:flutter/material.dart';

import '../theme/app_logo.dart';
import '../theme/brand.dart';

/// Ditampilkan selama status login belum diketahui.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(child: AppLogo(size: 80)),
            const SizedBox(height: 16),
            Text(Brand.appName, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
