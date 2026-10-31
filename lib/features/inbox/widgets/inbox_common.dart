import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/user.dart';
import '../../../data/repositories/repositories.dart';

export 'conversation_actions.dart';
export 'inbox_filter.dart';
export 'label_picker.dart';

/// Bộ nhớ đệm người dùng (đối tác hội thoại) cho State.
mixin ParticipantCache<T extends StatefulWidget> on State<T> {
  final Map<String, AppUser> users = {};
  final Set<String> _pending = {};

  /// Gọi được trong build: chỉ tải những id chưa có.
  void ensureUsers(Iterable<String> ids) {
    final missing = ids.where((id) => !users.containsKey(id) && !_pending.contains(id)).toSet().toList();
    if (missing.isEmpty) return;
    _pending.addAll(missing);
    context
        .read<CatalogRepository>()
        .usersByIds(missing)
        .then((list) {
          if (!mounted) return;
          setState(() {
            for (final u in list) {
              users[u.id] = u;
            }
          });
        })
        .catchError((Object _) {
          _pending.removeAll(missing);
        });
  }
}
