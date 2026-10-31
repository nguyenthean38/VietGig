import 'package:flutter/widgets.dart';

/// Thang khoảng cách (bội số 4). Dùng thay cho số gõ tay.
abstract final class Space {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;

  /// Khoảng đệm đáy cho màn hình trong tab (tránh thanh điều hướng nổi).
  static const double navBarClearance = 110;
}

/// Bo góc.
abstract final class Radii {
  static const double xs = 4;
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 12;
  static const double sm2 = 8;
  static const double xl = 18;
  static const double xxl = 24;
  static const double pill = 40;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius sm2All = BorderRadius.all(Radius.circular(sm2));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlAll = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}

/// Padding hay dùng.
abstract final class Insets {
  /// Lề ngang chuẩn của trang.
  static const page = EdgeInsets.symmetric(horizontal: Space.lg);
  static const pageAll = EdgeInsets.all(Space.lg);
  static const card = EdgeInsets.all(Space.lg);
  static const cardSm = EdgeInsets.all(Space.md);

  /// Màn hình trong tab: lề ngang + đệm đáy cho thanh điều hướng.
  static const tabPage = EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.navBarClearance);
  static const tabBottom = EdgeInsets.only(bottom: Space.navBarClearance);
}

/// Khoảng trống cố định. VD: `Gaps.v12` (dọc 12), `Gaps.h8` (ngang 8).
abstract final class Gaps {
  static const v2 = SizedBox(height: Space.xxs);
  static const v4 = SizedBox(height: Space.xs);
  static const v6 = SizedBox(height: 6);
  static const v8 = SizedBox(height: Space.sm);
  static const v10 = SizedBox(height: 10);
  static const v12 = SizedBox(height: Space.md);
  static const v14 = SizedBox(height: 14);
  static const v16 = SizedBox(height: Space.lg);
  static const v20 = SizedBox(height: Space.xl);
  static const v24 = SizedBox(height: Space.xxl);
  static const v28 = SizedBox(height: 28);
  static const v32 = SizedBox(height: Space.xxxl);
  static const v48 = SizedBox(height: Space.huge);

  static const h2 = SizedBox(width: Space.xxs);
  static const h4 = SizedBox(width: Space.xs);
  static const h6 = SizedBox(width: 6);
  static const h8 = SizedBox(width: Space.sm);
  static const h10 = SizedBox(width: 10);
  static const h12 = SizedBox(width: Space.md);
  static const h14 = SizedBox(width: 14);
  static const h16 = SizedBox(width: Space.lg);
  static const h20 = SizedBox(width: Space.xl);
  static const h24 = SizedBox(width: Space.xxl);
}
