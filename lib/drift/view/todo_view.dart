import 'package:flutter/material.dart';
import 'package:thuyet_trinh_ltdd/drift/model/database.dart';
import 'package:thuyet_trinh_ltdd/main.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  void _showAddTodoSheet(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Thêm Công Việc Mới',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề (Bắt buộc)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Nội dung (Không bắt buộc)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  // ------------------------------
                  // Gọi hàm thêm
                  // ------------------------------
                  await database.todoDao.addTodo(
                    titleController.text,
                    contentController.text,
                  );
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Lưu vào SQLite'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drift SQLite'),
        backgroundColor: Colors.blue.shade100,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Todo>>(
        // ------------------------------
        // Lắng nghe Stream tự động
        // ------------------------------
        stream: database.todoDao.watchAllTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final todos = snapshot.data ?? [];

          if (todos.isEmpty) {
            return const Center(
              child: Text('Chưa có công việc nào. Nhấn nút + bên dưới!'),
            );
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) async {
                      // ------------------------------
                      // Thay đổi trạng thái completed
                      // ------------------------------
                      await database.todoDao.toggleTodoStatus(todo);
                    },
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: todo.content != null ? Text(todo.content!) : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      // ------------------------------
                      // Xóa item
                      // ------------------------------
                      await database.todoDao.deleteTodo(todo);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
