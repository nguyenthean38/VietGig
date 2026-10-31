import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Tệp đính kèm mô phỏng.
class FakeFile {
  const FakeFile(this.name, this.size, {this.progress = 1});
  final String name;
  final String size;
  final double progress;
  bool get uploading => progress < 1;
  FakeFile withProgress(double p) => FakeFile(name, size, progress: p);
}

final _rand = Random();

/// Tạo tên tệp mô phỏng theo nguồn đã chọn (dữ liệu mẫu).
FakeFile makeFakeFile(String source, int index) {
  final n = index + 1;
  return switch (source) {
    'camera' => FakeFile('Anh-chup-$n.jpg', '${180 + _rand.nextInt(800)} KB'),
    'gallery' => FakeFile('Hinh-anh-$n.png', '${200 + _rand.nextInt(900)} KB'),
    _ => FakeFile(n == 1 ? 'Tệp-PDF.pdf' : 'Tệp-PDF-$n.pdf', n == 1 ? '14 KB' : '${10 + _rand.nextInt(90)} KB'),
  };
}

/// Bottom sheet chọn nguồn tệp. Trả về 'camera' | 'gallery' | 'file'.
Future<String?> showAttachSheet(BuildContext context) {
  final l = context.l10n;
  return showActionSheet<String>(
    context,
    title: l.ordersAttachTitle,
    actions: [
      SheetAction(label: l.ordersAttachCamera, value: 'camera', icon: Icons.photo_camera_outlined),
      SheetAction(label: l.ordersAttachGallery, value: 'gallery', icon: Icons.photo_library_outlined),
      SheetAction(label: l.ordersAttachFile, value: 'file', icon: Icons.attach_file_rounded),
    ],
  );
}

/// Ô hiển thị một tệp (có nút xoá / tiến trình tải lên).
class FileTile extends StatelessWidget {
  const FileTile({super.key, required this.name, this.size, this.onRemove, this.progress = 1, this.onTap});
  final String name;
  final String? size;
  final VoidCallback? onRemove;
  final double progress;
  final VoidCallback? onTap;

  IconData get _icon {
    final n = name.toLowerCase();
    if (n.endsWith('.png') || n.endsWith('.jpg') || n.endsWith('.jpeg')) return Icons.image_outlined;
    if (n.endsWith('.zip')) return Icons.folder_zip_outlined;
    if (n.endsWith('.pdf')) return Icons.picture_as_pdf_outlined;
    return Icons.insert_drive_file_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: cs.surfaceContainerHighest, borderRadius: BorderRadius.circular(Space.sm)),
            child: Icon(_icon, color: cs.onSurfaceVariant),
          ),
          Gaps.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 3),
                if (progress < 1)
                  Padding(
                    padding: const EdgeInsets.only(top: Space.xs),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Radii.xs),
                      child: LinearProgressIndicator(value: progress, minHeight: 4, color: context.tokens.brand),
                    ),
                  )
                else if (size != null)
                  Text(size!, style: context.textTheme.bodySmall),
              ],
            ),
          ),
          if (onRemove != null)
            IconButton(
              tooltip: context.l10n.ordersRemoveFile,
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded, size: 20),
            ),
        ],
      ),
    );
  }
}
