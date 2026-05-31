import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    // 1. Cấu hình các thông số cơ bản (BaseOptions)
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com', // API giả lập để test
        connectTimeout: const Duration(seconds: 5), // Chờ kết nối 5s
        receiveTimeout: const Duration(seconds: 3), // Chờ nhận dữ liệu 3s
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 2. Thêm Interceptor (Bộ chặn) để Debug
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("➡️ [REQUEST] Gửi đi: ${options.method} - ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("⬅️ [RESPONSE] Nhận về: ${response.statusCode}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print("❌ [ERROR] Lỗi xảy ra: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  // 3. Hàm gọi API
  Future<List<dynamic>> getPosts() async {
    try {
      final response = await _dio.get('/posts');
      return response.data; // Dio tự động parse thành List/Map
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // 4. Hàm xử lý phân loại lỗi
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return "Kết nối mạng quá hạn (Timeout). Vui lòng thử lại!";
      case DioExceptionType.badResponse:
        return "Lỗi từ Server: Code ${error.response?.statusCode}";
      default:
        return "Đã xảy ra lỗi không xác định: ${error.message}";
    }
  }
}