import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../state/app_controllers.dart';
import 'widgets/settings_widgets.dart';

/// Cài đặt thông báo: 2 tab Thông báo đẩy / Email.
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsController>();
    final l = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: SimpleAppBar(
          title: l.profileNotifications,
          bottom: TabBar(
            tabs: [
              Tab(text: l.profilePushTab),
              Tab(text: l.profileEmailTab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _List(
              id: 'push',
              values: s.push,
              onChanged: s.setPush,
              testLabel: l.profileSendTestPush,
              onTest: () => showAppSnack(context, l.profileTestPushSent),
            ),
            _List(
              id: 'email',
              values: s.email,
              onChanged: s.setEmail,
              testLabel: l.profileSendTestEmail,
              onTest: () => showAppSnack(context, l.profileTestEmailSent),
            ),
          ],
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({
    required this.id,
    required this.values,
    required this.onChanged,
    required this.testLabel,
    required this.onTest,
  });
  final String id;
  final Map<String, bool> values;
  final void Function(String, bool) onChanged;
  final String testLabel;
  final VoidCallback onTest;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: ListView(
          children: [
            for (final e in values.entries)
              SwitchRow(
                switchKey: ValueKey('${id}_${e.key}'),
                title: notificationKeyLabel(context.l10n, e.key),
                value: e.value,
                onChanged: (v) => onChanged(e.key, v),
              ),
          ],
        ),
      ),
      SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.md),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(key: ValueKey('test_$id'), onPressed: onTest, child: Text(testLabel)),
          ),
        ),
      ),
    ],
  );
}
