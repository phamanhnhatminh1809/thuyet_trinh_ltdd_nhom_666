import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thuyet_trinh_ltdd/Riverpod/view/riverpod_demo_screen.dart';
import 'package:thuyet_trinh_ltdd/drift/model/database.dart';
import 'package:thuyet_trinh_ltdd/drift/view/todo_view.dart';

// Khởi tạo global instance cho database để dùng toàn app
late AppDatabase database;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  database = AppDatabase();
  runApp(
    // Wrap ứng dụng trong ProviderScope để khởi tạo Riverpod
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drift Demo Todo App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Danh sách 3 màn hình
  final List<Widget> _screens = [
    const TodoScreen(),
    const Scaffold(body: Center(child: Text('Dio'))),
    const RiverpodDemoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Todo'),
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'Dio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Count',
          ),
        ],
      ),
    );
  }
}
