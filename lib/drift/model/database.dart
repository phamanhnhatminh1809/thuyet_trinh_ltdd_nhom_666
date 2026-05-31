import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'table.dart';
import 'todos_dao.dart';

export 'table.dart';
export 'todos_dao.dart';

// 1. Khai báo sinh mã ngầm
part 'database.g.dart';

// 2. Chỉ định Driff biết database này chứa những table nào và daos nào
@DriftDatabase(tables: [Todos], daos: [TodoDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;

  @override
  TodoDao get todoDao => TodoDao(this);
}

// 3. Hàm tạo kết nối vật lý
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
