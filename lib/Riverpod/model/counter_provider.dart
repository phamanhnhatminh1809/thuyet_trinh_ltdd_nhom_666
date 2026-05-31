import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StateProvider là một loại provider đơn giản dùng cho các state cơ bản (như int, bool, String).
/// Ở đây ta dùng nó để quản lý một giá trị counter (số nguyên).
final counterProvider = StateProvider<int>((ref) {
  return 0; // Giá trị khởi tạo là 0
});
