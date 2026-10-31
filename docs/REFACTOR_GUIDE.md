# Hướng dẫn chuẩn hoá (đợt 2): Token, Spacing, Đa ngôn ngữ, Tách file

Đọc kèm `docs/DEV_GUIDE.md`. Mục tiêu: đưa code về chuẩn frontend Flutter. App phải **giữ nguyên giao diện & hành vi**,
chỉ thay cách viết. Toàn bộ test hiện có phải tiếp tục pass.

## 1. Màu: dùng token thay cho AppColors
- `import '../../core/l10n/l10n.dart';` (đường dẫn tương đối theo file) cung cấp extension:
  - `context.tokens` → `AppTokens` (ThemeExtension, có bản sáng/tối): `brand, brandStrong, brandSoft, onBrand,
    success, successSoft, warning, warningSoft, danger, dangerSoft, info, infoSoft, navy, plum,
    vettedBg, vettedFg, topRatedBg, topRatedFg, proTag, badge, starGold, overlay`.
  - `context.colors` → `ColorScheme` (onSurface, onSurfaceVariant, outline, outlineVariant, surface, surfaceContainerHighest…)
  - `context.textTheme`.
- **Không dùng `AppColors.xxx` trong `lib/features/**`**, trừ `AppColors.fromSeed(...)`/`AppColors.palette` (màu trang trí).
  Ánh xạ gợi ý: brand→tokens.brand, brandDark→tokens.brandStrong, brandSoft→tokens.brandSoft, danger→tokens.danger,
  dangerSoft→tokens.dangerSoft, warning(Soft)→tokens.warning(Soft), blue→tokens.info, blueSoft→tokens.infoSoft,
  navy→tokens.navy, plum→tokens.plum, ink→colors.onSurface, muted→colors.onSurfaceVariant, subtle/border→colors.outline,
  divider→colors.outlineVariant, fill/background→colors.surfaceContainerHighest, vetted*/topRated* → tokens tương ứng,
  `Color(0xFFE5508A)`→tokens.badge, `Color(0xFF6E5BF5)`→tokens.proTag. Màu chữ trắng trên nền màu đậm giữ `Colors.white`.
- Không gõ mã màu `Color(0xFF......)` mới trong feature.

## 2. Khoảng cách & bo góc: dùng token
`import '../../core/theme/spacing.dart';`
- `Space.xxs(2) xs(4) sm(8) md(12) lg(16) xl(20) xxl(24) xxxl(32) huge(48)`, `Space.navBarClearance` (110).
- `Gaps.v4/v6/v8/v10/v12/v16/v20/v24/v32/v48`, `Gaps.h2/h4/h6/h8/h10/h12/h16/h20/h24` thay `SizedBox(height/width: n)`.
- `Insets.page` (ngang 16), `Insets.pageAll`, `Insets.card`, `Insets.cardSm`, `Insets.tabPage`, `Insets.tabBottom`.
- `Radii.xs/sm/md/lg/xl/pill`, `Radii.smAll/mdAll/lgAll/pillAll` thay `BorderRadius.circular(n)`.
- Giá trị lẻ không có trong thang (VD 3, 14, 18) được phép giữ nếu thật sự cần, nhưng ưu tiên làm tròn về thang.

## 3. Đa ngôn ngữ (gen-l10n, .arb) — tiếng Việt (mặc định) + tiếng Anh
- Mỗi nhóm có file riêng: `lib/l10n/parts/<nhóm>_vi.arb` và `<nhóm>_en.arb` (JSON). **Khoá phải bắt đầu bằng tiền tố nhóm**
  (VD `ordersManageTitle`, `inboxEmptyTitle`) để không trùng. Khoá camelCase, chỉ chữ/số.
- Chuỗi có biến: dùng placeholder + metadata trong file **vi**:
  ```json
  "ordersDueIn": "Đến hạn trong {days} ngày",
  "@ordersDueIn": {"placeholders": {"days": {"type": "int"}}}
  ```
  File en chỉ cần giá trị (`"ordersDueIn": "Due in {days} days"`). Số nhiều tiếng Anh: `{n, plural, =1{1 day} other{{n} days}}`.
  Placeholder kiểu chuỗi: `{"type": "String"}`. Không nhét ký tự `{`/`}` lẻ vào chuỗi (ICU sẽ lỗi).
- Sau khi sửa .arb: `python tool/l10n_merge.py` (gộp + `flutter gen-l10n`). Lỗi do file của nhóm khác đang sửa dở → đợi vài giây chạy lại.
  Ghi file .arb trọn vẹn một lần (dùng công cụ Write) để không để lại JSON hỏng cho người khác.
- Trong widget: `context.l10n.ordersManageTitle`, `context.l10n.ordersDueIn(3)`. Ngoài widget (hàm tiện ích) truyền `AppLocalizations l`.
- Chuỗi chung đã có sẵn trong `core` (dùng lại, đừng tạo trùng): `commonSeeAll, commonCancel, commonOk, commonAgree, commonUndo,
  commonBack, commonClose, commonSave, commonSaved, commonDone, commonDelete, commonCreate, commonOr, commonSignIn, commonMessage,
  commonErrorTitle, commonRetry, commonFrom, timeDays/Hours/Minutes, timeNDays(n), nav*, orderStatus*, level*, sort*,
  offerStatus*, revisionsUnlimited, notifKey*, languageVietnamese, languageEnglish`. Xem `lib/l10n/parts/core_vi.arb`.
- Enum: dùng `status.localized(context.l10n)`, `status.fg/bg(context.tokens, context.colors)` (OrderStatus),
  `level.localized(...)`, `sort.localized(...)`, `offerStatus.localized(...)`, `package.revisionsLocalized(...)`.
  Getter cũ `.label/.color/.background/.revisionsLabel` đã **@Deprecated** → analyzer báo, phải thay hết.
- Hàm `Fmt` (ngày, “x phút trước”, `Fmt.days(n)`) đã tự dịch theo ngôn ngữ hiện tại. Tiền vẫn là VND.
- **Dữ liệu mẫu** (tên gig, mô tả, tin nhắn, tên người, câu hỏi yêu cầu, nhãn hội thoại do người dùng tạo) là *dữ liệu*,
  giữ nguyên, không dịch.
- `SettingsController`: `language/setLanguage` đã thay bằng `locale` (`Locale('vi'|'en')`) + `setLocale`.
  `push`/`email` giờ dùng khoá cố định (`inbox, orderMessages, orderUpdates, ratingReminders, buyerBriefs, myGigs,
  myAccount, promotions`); nhãn hiển thị: `notificationKeyLabel(context.l10n, key)`.
- Test hiện có tìm chữ tiếng Việt → **giữ y nguyên câu tiếng Việt** khi chuyển vào .arb (copy chính xác).

## 4. Tách file dài
- Mục tiêu: mỗi file trong `lib/features/**` **≤ 400 dòng** (sau `dart format -l 120`).
- Tách widget con ra `lib/features/<nhóm>/widgets/<tên>.dart` (class public, đặt tên rõ ràng), hoặc tách thành các file
  section (VD `order_detail/timeline_section.dart`). Không đổi tên class màn hình/constructor mà router dùng.

## Hoàn thành khi
- `python tool/l10n_merge.py` OK.
- `dart format -l 120 <thư mục của bạn> <test của bạn>` đã chạy.
- `flutter analyze lib/features/<nhóm> test/<test>` = 0 issue (kể cả deprecated).
- `grep -rn "AppColors\." lib/features/<nhóm>` chỉ còn `fromSeed`/`palette`.
- Không còn chuỗi tiếng Việt hiển thị viết cứng trong file của bạn (trừ dữ liệu mẫu / log / comment).
- Test cũ của nhóm pass + thêm 1 test: đổi sang tiếng Anh (`context.read<SettingsController>().setLocale(const Locale('en'))`
  rồi `settle`) và thấy chữ tiếng Anh trên một màn hình của nhóm.
