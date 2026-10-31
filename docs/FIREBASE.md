# Nối Firebase cho VietGig

Hiện app chạy hoàn toàn bằng **dữ liệu mock** (giả lập trong bộ nhớ). Toàn bộ giao diện chỉ gọi qua
5 interface trong `lib/data/repositories/repositories.dart`, nên chuyển sang Firebase **không phải sửa màn hình nào**,
chỉ cần viết bản cài đặt Firebase cho 5 interface đó và đổi 1 dòng trong `lib/main.dart`.

## Bạn cần làm (phần cần tài khoản của bạn)

1. Tạo project trên https://console.firebase.google.com (VD tên `vietgig`).
2. Bật các dịch vụ:
   - **Authentication** → Sign-in method: *Email/Password*, *Google* (tuỳ chọn: Apple, Facebook).
   - **Cloud Firestore** → tạo database (chọn vùng `asia-southeast1`), bắt đầu ở *production mode*.
   - **Storage** (để lưu ảnh dịch vụ, tệp đính kèm, bản giao).
   - (Tuỳ chọn) **Cloud Messaging** cho thông báo đẩy.
3. Cài công cụ trên máy (một lần):
   ```
   npm install -g firebase-tools
   firebase login
   dart pub global activate flutterfire_cli
   ```
4. Trong thư mục `D:\CV\viet_gig` chạy:
   ```
   flutterfire configure --project=<id-project-cua-ban>
   ```
   Lệnh này tạo `lib/firebase_options.dart` và file cấu hình Android/iOS.
5. Báo lại cho mình là xong → mình sẽ viết phần còn lại (bên dưới).

## Mình sẽ làm sau khi bạn cấu hình xong

- Thêm package: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `google_sign_in`.
- Viết `lib/data/firebase/`:
  - `FirebaseAuthRepository` (đăng ký/đăng nhập, xác minh email, đổi email, xoá tài khoản).
  - `FirestoreCatalogRepository`, `FirestoreOrderRepository`, `FirestoreChatRepository`, `FirestoreAccountRepository`.
- Thêm `AppServices.firebase()` trong `lib/data/services.dart` và đổi `main.dart`.
- Script seed: đẩy dữ liệu mẫu từ `lib/data/mock/mock_data.dart` lên Firestore.
- Viết **Security Rules** cho Firestore/Storage.
- Chat realtime bằng `snapshots()` (hiện tại mock dùng Future).

## Cấu trúc Firestore dự kiến

| Collection | Document | Nội dung chính |
|---|---|---|
| `users` | `{uid}` | `AppUser.toMap()` – hồ sơ, cấp độ, isSeller… |
| `users/{uid}/savedLists` | `{listId}` | tên, gigIds, sellerIds, isPublic |
| `users/{uid}/notifications` | `{id}` | title, body, kind, read, link, createdAt |
| `users/{uid}/private` | `settings`, `history`, `interests`, `availability` | dữ liệu riêng tư |
| `categories` | `{id}` | name, subtitle, icon, subcategories[] |
| `gigs` | `{gigId}` | sellerId, title, description, packages[], extras[], faqs[], tags[], rating… |
| `reviews` | `{id}` | sellerId, gigId, author, rating, text, createdAt, sellerResponse |
| `orders` | `{orderId}` | buyerId, sellerId, gig snapshot, status, totals, dueDate, requirementAnswers, pendingRequest |
| `orders/{id}/events` | `{eventId}` | type, title, body, at, attachments |
| `orders/{id}/deliveries` | `{id}` | message, files[], at |
| `conversations` | `{convId}` | members[2], lastMessage, updatedAt, unread{uid:n}, labels{uid:[]}, archivedBy[] |
| `conversations/{id}/messages` | `{msgId}` | senderId, type, text, file, offer{…}, sentAt |

Quy tắc chính: chỉ người trong `members` đọc/ghi hội thoại; chỉ buyer/seller của đơn đọc đơn;
chỉ chủ gig sửa gig; trạng thái đơn chuyển bằng Cloud Function (an toàn hơn) hoặc rule kiểm tra chuyển trạng thái hợp lệ.

> Lưu ý: thanh toán thật (thẻ, MoMo, ZaloPay) cần cổng thanh toán riêng + backend (Cloud Functions);
> hiện màn thanh toán chỉ mô phỏng.
