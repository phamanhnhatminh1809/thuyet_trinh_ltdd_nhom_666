import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider này dùng để giả lập việc bật/tắt lỗi từ giao diện.
final simulateErrorProvider = StateProvider<bool>((ref) => false);

/// FutureProvider dùng để xử lý các tác vụ bất đồng bộ (Async).
final userProvider = FutureProvider<String>((ref) async {
  // Lắng nghe trạng thái giả lập lỗi.
  final shouldError = ref.watch(simulateErrorProvider);

  // Giả lập độ trễ mạng 2 giây để thấy trạng thái Loading.
  await Future.delayed(const Duration(seconds: 2));
  
  if (shouldError) {
    throw Exception("Mất kết nối máy chủ (Lỗi 500) - Vui lòng thử lại sau!");
  }

  // Lấy thời gian hiện tại để chứng minh dữ liệu được cập nhật mới sau mỗi lần Refresh.
  final now = DateTime.now();
  final timestamp = "${now.hour}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

  // Trả về dữ liệu giả lập với tên phổ thông.
  return "Dữ liệu người dùng nhận lúc: $timestamp\nTên: Nguyễn Văn A";
});
