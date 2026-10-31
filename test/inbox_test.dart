import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:viet_gig/data/models/chat.dart';
import 'package:viet_gig/features/inbox/chat_screen.dart';
import 'package:viet_gig/features/inbox/create_offer_screen.dart';
import 'package:viet_gig/state/app_controllers.dart';
import 'package:viet_gig/state/session_controller.dart';

import 'helpers.dart';

Finder _key(String k) => find.byKey(ValueKey(k));

Future<void> _tap(WidgetTester tester, Finder f) async {
  await Scrollable.ensureVisible(tester.element(f), alignment: 0.5);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

Future<void> _swipe(WidgetTester tester, String convId) async {
  await tester.drag(_key('conv_$convId'), const Offset(-320, 0));
  await settle(tester);
}

void main() {
  testWidgets('Hộp thư hiển thị danh sách và lọc Lưu trữ', (tester) async {
    await pumpApp(tester, location: '/inbox');
    expect(tester.takeException(), isNull);
    expect(find.text('Hộp thư'), findsWidgets);
    expect(find.text('Hoàng Nguyễn'), findsOneWidget);
    expect(find.text('Tuấn Lê'), findsOneWidget);
    expect(find.text('Đơn đang thực hiện'), findsOneWidget); // nhãn
    expect(find.text('Mai Võ'), findsNothing); // đã lưu trữ

    await _tap(tester, _key('inbox_filter'));
    expect(find.text('Bộ lọc'), findsOneWidget);
    await _tap(tester, _key('filter_Lưu trữ'));
    expect(tester.widget<Text>(_key('inbox_title')).data, 'Lưu trữ');
    expect(find.text('Mai Võ'), findsOneWidget);
    expect(find.text('Hoàng Nguyễn'), findsNothing);

    // Lọc không có kết quả -> nút Xoá bộ lọc.
    await _tap(tester, _key('inbox_filter'));
    await _tap(tester, _key('filter_Spam'));
    expect(find.text('Thử điều chỉnh bộ lọc'), findsOneWidget);
    expect(find.text('Không có kết quả cho Spam.'), findsOneWidget);
    await _tap(tester, find.text('Xoá bộ lọc'));
    expect(find.text('Hoàng Nguyễn'), findsOneWidget);
  });

  testWidgets('Chế độ Sửa: chọn nhiều và lưu trữ', (tester) async {
    await pumpApp(tester, location: '/inbox');
    await _tap(tester, _key('inbox_edit'));
    expect(find.text('Xong'), findsOneWidget);
    await _tap(tester, find.text('Tuấn Lê'));
    await _tap(tester, find.text('Bảo Trần'));
    expect(find.text('2 đã chọn'), findsOneWidget);

    await _tap(tester, _key('edit_archive'));
    expect(find.text('Tuấn Lê'), findsNothing);
    expect(find.text('Bảo Trần'), findsNothing);
    expect(find.text('Đã lưu trữ 2 cuộc trò chuyện'), findsOneWidget);
    expect(find.text('Hoàn tác'), findsOneWidget);

    await tester.tap(find.text('Hoàn tác'));
    await settle(tester);
    expect(find.text('Tuấn Lê'), findsOneWidget);
    await settle(tester, 40); // chờ snack đóng
  });

  testWidgets('Vuốt trái -> Thêm -> Đổi nhãn', (tester) async {
    await pumpApp(tester, location: '/inbox');
    await _swipe(tester, 'c_tuan');
    expect(_key('swipe_more_c_tuan'), findsOneWidget);
    await _tap(tester, _key('swipe_more_c_tuan'));
    await _tap(tester, _key('more_labels'));
    expect(find.text('Chọn nhãn'), findsOneWidget);
    await _tap(tester, _key('label_Cần theo dõi'));

    // Thêm nhãn mới.
    await _tap(tester, _key('label_add'));
    await tester.enterText(_key('label_new_field'), 'Khách VIP');
    await _tap(tester, _key('label_new_save'));
    await _tap(tester, _key('labels_apply'));

    expect(find.text('Cần theo dõi'), findsOneWidget);
    expect(find.text('Khách VIP'), findsOneWidget);
    await settle(tester, 40);
  });

  testWidgets('Xoá hội thoại cần xác nhận', (tester) async {
    await pumpApp(tester, location: '/inbox');
    await _swipe(tester, 'c_bao');
    await _tap(tester, _key('swipe_more_c_bao'));
    await _tap(tester, _key('more_delete'));
    expect(find.text('Xoá cuộc trò chuyện?'), findsOneWidget);
    await _tap(tester, _key('confirm_ok'));
    expect(find.text('Bảo Trần'), findsNothing);
    await settle(tester, 40);
  });

  testWidgets('Chat: gửi tin nhắn và nhận phản hồi mô phỏng', (tester) async {
    await pumpApp(tester, location: '/chat/c_hoang');
    expect(find.byType(ChatScreen), findsOneWidget);
    expect(find.text('Hoàng Nguyễn'), findsWidgets);

    final send = tester.widget<IconButton>(_key('chat_send'));
    expect(send.onPressed, isNull); // khoá khi rỗng

    await tester.enterText(_key('chat_input'), 'Anh gửi giúp em timeline nhé');
    await tester.pump();
    await _tap(tester, _key('chat_send'));
    expect(find.text('Anh gửi giúp em timeline nhé'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await settle(tester);
    expect(find.text('Cảm ơn bạn! Mình sẽ phản hồi chi tiết sớm nhé.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Chat: trả lời nhanh chèn nội dung với tên đối tác', (tester) async {
    await pumpApp(tester, location: '/chat/c_hoang');
    await _tap(tester, _key('chat_quick'));
    expect(find.text('Trả lời nhanh'), findsOneWidget);
    await _tap(tester, _key('quick_q1'));
    final field = tester.widget<TextField>(_key('chat_input'));
    expect(field.controller!.text, 'Chào Hoàng Nguyễn, mình bắt đầu ngay nhé!');
  });

  testWidgets('Xem báo giá theo cột mốc', (tester) async {
    await pumpApp(tester, location: '/chat/c_hoang/offer/m4');
    expect(find.text('Xem báo giá theo cột mốc'), findsOneWidget);
    expect(find.text('Wireframe & Concept giao diện'), findsOneWidget);
    expect(find.text('Chi tiết cột mốc'), findsOneWidget);
    expect(find.text('3 ngày | 1.250.000 ₫ | 2 lượt sửa'), findsOneWidget);
    await tester.scrollUntilVisible(_key('offer_total'), 200);
    expect(tester.widget<Text>(_key('offer_total')).data, '5.000.000 ₫');
    expect(_key('offer_checkout'), findsOneWidget);
    expect(find.textContaining('Bạn chỉ bị tính phí cho cột mốc đầu tiên'), findsOneWidget);
  });

  testWidgets('Người bán tạo báo giá -> tin báo giá mới xuất hiện', (tester) async {
    final services = await pumpApp(tester, location: '/chat/c_hoang');
    final ctx = tester.element(find.byType(ChatScreen));
    await ctx.read<SessionController>().setSellerMode(true);
    await settle(tester);

    await _tap(tester, _key('chat_attach'));
    expect(_key('attach_offer'), findsOneWidget);
    await _tap(tester, _key('attach_offer'));
    expect(find.byType(CreateOfferScreen), findsOneWidget);

    // Gửi khi chưa nhập -> báo lỗi.
    await _tap(tester, _key('offer_send'));
    expect(find.text('Vui lòng nhập mô tả báo giá'), findsOneWidget);

    const desc = 'Thiết kế 3 màn hình onboarding cho ứng dụng bán hàng, kèm file Figma.';
    await tester.enterText(_key('offer_desc'), desc);
    await tester.enterText(_key('offer_price'), '2500000');
    await _tap(tester, _key('offer_days'));
    await _tap(tester, _key('days_5'));
    await _tap(tester, _key('offer_send'));

    expect(find.byType(CreateOfferScreen), findsNothing);
    expect(find.text('Đã gửi báo giá'), findsOneWidget);
    final msgs = await services.chat.messages('c_hoang');
    final offer = msgs.lastWhere((m) => m.type == MessageType.offer).offer!;
    expect(offer.description, desc);
    expect(offer.price, 2500000);
    expect(offer.deliveryDays, 5);
    expect(find.text(desc), findsOneWidget);
    expect(find.text('Rút lại báo giá'), findsWidgets);
    await settle(tester, 40);
  });

  testWidgets('Không tràn bố cục ở màn hình hẹp 360px', (tester) async {
    await pumpApp(tester, location: '/inbox', size: const Size(360, 720));
    expect(tester.takeException(), isNull);
    await _tap(tester, _key('inbox_edit'));
    await _tap(tester, find.text('Tuấn Lê'));
    expect(tester.takeException(), isNull);
    await _tap(tester, find.text('Tuấn Lê'));
    await _tap(tester, _key('inbox_edit'));
    await _tap(tester, find.text('Hoàng Nguyễn'));
    expect(find.byType(ChatScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      _key('offer_decline_o1'),
      -200,
      scrollable: find.descendant(of: _key('chat_list'), matching: find.byType(Scrollable)),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Người bán tạo báo giá theo cột mốc (màn hình 360px)', (tester) async {
    final services = await pumpApp(tester, location: '/chat/c_tuan', size: const Size(360, 740));
    await tester.element(find.byType(ChatScreen)).read<SessionController>().setSellerMode(true);
    await settle(tester);
    await _tap(tester, _key('chat_attach'));
    await _tap(tester, _key('attach_offer'));
    await tester.enterText(_key('offer_desc'), 'Thiết kế trọn bộ giao diện app theo từng giai đoạn.');
    await _tap(tester, _key('offer_pay_type'));
    await _tap(tester, _key('pay_milestone'));

    for (var i = 0; i < 2; i++) {
      await _tap(tester, _key('milestone_add'));
      expect(find.text('Cột mốc ${i + 1}'), findsOneWidget);
      await tester.enterText(_key('ms_title'), 'Giai đoạn ${i + 1}');
      await tester.enterText(_key('ms_desc'), 'Bàn giao giai đoạn ${i + 1}');
      await tester.enterText(_key('ms_price'), '1000000');
      await _tap(tester, _key('ms_days'));
      await _tap(tester, _key('msdays_3'));
      await _tap(tester, _key('ms_save'));
      expect(tester.takeException(), isNull);
    }
    expect(find.text('Giai đoạn 2'), findsOneWidget);

    await _tap(tester, _key('offer_options'));
    await _tap(tester, _key('opt_wireframe'));
    await _tap(tester, _key('pages_plus'));
    await _tap(tester, _key('options_apply'));
    expect(find.text('Đã chọn 2'), findsOneWidget);

    await _tap(tester, _key('offer_send'));
    expect(tester.takeException(), isNull);
    final msgs = await services.chat.messages('c_tuan');
    final offer = msgs.lastWhere((m) => m.type == MessageType.offer).offer!;
    expect(offer.milestones.length, 2);
    expect(offer.totalPrice, 2000000);
    expect(offer.serviceOptions, ['1 trang/màn hình', 'Wireframe']);
    expect(find.text('2 cột mốc'), findsOneWidget);
    await settle(tester, 40);
  });

  testWidgets('/contact/u_tuan chuyển vào màn chat', (tester) async {
    await pumpApp(tester, location: '/contact/u_tuan');
    await settle(tester);
    expect(find.byType(ChatScreen), findsOneWidget);
    expect(find.text('Tuấn Lê'), findsWidgets);
    expect(find.textContaining('Bạn đang tìm người thiết kế app?'), findsOneWidget);
  });

  testWidgets('Đổi sang tiếng Anh: Hộp thư và Chat hiển thị tiếng Anh', (tester) async {
    await pumpApp(tester, location: '/inbox');
    tester.element(find.byType(Scaffold).first).read<SettingsController>().setLocale(const Locale('en'));
    await settle(tester);
    expect(tester.widget<Text>(_key('inbox_title')).data, 'Inbox');
    expect(find.text('Edit'), findsOneWidget);
    await _tap(tester, _key('inbox_filter'));
    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('Archived'), findsOneWidget);
    expect(find.text('Labels'), findsOneWidget);
    await _tap(tester, _key('filter_Spam'));
    expect(find.text('Try adjusting your filters'), findsOneWidget);
    expect(find.text('No results for Spam.'), findsOneWidget);

    await _tap(tester, find.text('Clear filters'));
    await _tap(tester, find.text('Hoàng Nguyễn'));
    expect(find.byType(ChatScreen), findsOneWidget);
    expect(find.byTooltip('Active orders'), findsOneWidget);
    expect(find.byTooltip('Quick responses'), findsOneWidget);
    expect(find.text('View full offer'), findsWidgets);
    expect(tester.widget<TextField>(_key('chat_input')).decoration!.hintText, 'Type a message…');
    expect(tester.takeException(), isNull);
  });
}
