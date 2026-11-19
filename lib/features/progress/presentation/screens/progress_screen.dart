import 'package:flutter/material.dart';

import '../../../../core/utils/context_x.dart';
import '../../../../core/widgets/empty_state.dart';

/// Tab Progress. Isi dibangun pada fase sesuai IMPLEMENTATION_PLAN.md §4.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.tabProgress)),
      body: EmptyState(
        icon: Icons.insights_outlined,
        title: l.emptyProgressTitle,
        message: l.emptyProgressMessage,
      ),
    );
  }
}
