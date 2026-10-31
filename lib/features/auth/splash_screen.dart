import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';

/// Màn hình khởi động: chỉ hiển thị logo (router tự điều hướng khi khôi phục phiên xong).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.surface,
    body: const Center(child: BrandLogo(size: 46)),
  );
}
