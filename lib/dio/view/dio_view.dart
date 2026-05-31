import 'package:flutter/material.dart';
import '../service/api_service.dart';

class DioDemoScreen extends StatefulWidget {
  const DioDemoScreen({super.key});

  @override
  State<DioDemoScreen> createState() => _DioDemoScreenState();
}

class _DioDemoScreenState extends State<DioDemoScreen> {
  final ApiService _apiService = ApiService();
  
  List<dynamic> _posts = [];
  bool _isLoading = false;
  String _errorMessage = "";

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final data = await _apiService.getPosts();
      setState(() {
        _posts = data.take(10).toList(); // Lấy 10 bài viết đầu tiên để demo
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Không dùng Scaffold ở đây nữa vì main.dart đã có Scaffold rồi
    // Chỉ trả về Column nội dung
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Dio Demo - Fetch API',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _loadData,
          icon: const Icon(Icons.download),
          label: const Text('Tải dữ liệu bằng Dio'),
        ),
        const Divider(),
        Expanded(
          child: _buildBody(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }
    if (_posts.isEmpty) {
      return const Center(
        child: Text('Chưa có dữ liệu, hãy nhấn nút phía trên.'),
      );
    }

    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: CircleAvatar(child: Text("${post['id']}")),
            title: Text(
              post['title'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              post['body'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}