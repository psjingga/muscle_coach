import 'package:flutter/material.dart';

import '../../../../core/utils/context_x.dart';
import '../../../../core/widgets/empty_state.dart';

/// Tab Home. Isi dibangun pada fase sesuai IMPLEMENTATION_PLAN.md §4.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.tabHome)),
      body: EmptyState(
        icon: Icons.home_outlined,
        title: l.emptyHomeTitle,
        message: l.emptyHomeMessage,
      ),
    );
  }
}
