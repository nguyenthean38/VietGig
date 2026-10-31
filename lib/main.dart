import 'package:flutter/material.dart';

import 'app.dart';
import 'data/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Hiện đang dùng dữ liệu mock. Khi nối Firebase:
  //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //   runApp(VietGigApp(services: AppServices.firebase()));
  runApp(VietGigApp(services: AppServices.mock()));
}
