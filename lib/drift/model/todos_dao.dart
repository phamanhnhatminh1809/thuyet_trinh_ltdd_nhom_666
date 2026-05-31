import 'package:drift/drift.dart';
import 'database.dart';
part 'todos_dao.g.dart';

@DriftAccessor(tables: [Todos])
class TodoDao extends DatabaseAccessor<AppDatabase>
    with _$TodoDaoMixin {
  TodoDao(super.db);

  // 1. Lấy danh sách To-Do theo thời gian thực
  Stream<List<Todo>> watchAllTodos() {
    return select(todos).watch();
  }

  // 2. Thêm một To-Do mới
  Future<int> addTodo(String title, String? content) {
    return into(todos).insert(
      TodosCompanion.insert(title: title, content: Value(content)),
    );
  }

  // 3. Cập nhật trạng thái Hoàn thành / Chưa hoàn thành
  Future<bool> toggleTodoStatus(Todo todo) {
    return update(
      todos,
    ).replace(todo.copyWith(isCompleted: !todo.isCompleted));
  }

  // 4. Xóa một To-Do
  Future<int> deleteTodo(Todo todo) {
    return delete(todos).delete(todo);
  }
}
