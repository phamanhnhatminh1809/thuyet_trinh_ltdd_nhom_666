import 'package:drift/drift.dart';

class Todos extends Table {
  // Khóa chính tự động tăng
  IntColumn get id => integer().autoIncrement()();
  // Cột tiêu đề bắt buộc
  TextColumn get title => text()();
  // Cột nội dung cho phép null
  TextColumn get content => text().nullable()();
  // Cột trạng thái với giá trị mặc định
  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))();
}
