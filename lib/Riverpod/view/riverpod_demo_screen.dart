import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/counter_provider.dart';
import '../model/user_provider.dart';

/// Sử dụng ConsumerWidget để widget này có thể lắng nghe các Provider của Riverpod.
/// ConsumerWidget cung cấp thêm tham số 'ref' trong hàm build.
class RiverpodDemoScreen extends ConsumerWidget {
  const RiverpodDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 1. ref.watch() - Dùng để "lắng nghe" sự thay đổi của một provider.
    /// Khi giá trị của counterProvider thay đổi, hàm build này sẽ được gọi lại tự động để cập nhật UI.
    final count = ref.watch(counterProvider);

    /// 2. ref.watch() với FutureProvider - Xử lý dữ liệu bất đồng bộ.
    /// Nó trả về một đối tượng AsyncValue, cho phép chúng ta dùng hàm .when() rất tiện lợi.
    final asyncUser = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Demo'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần 1: Demo StateProvider (Counter)
            _buildSectionTitle(context, '1. StateProvider (Đếm số)'),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Giá trị hiện tại:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '$count',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      /// ref.read() - Dùng để truy cập provider mà KHÔNG lắng nghe (thường dùng trong hàm callback).
                      /// .notifier - Dùng để lấy ra bộ điều khiển trạng thái (state controller) để thay đổi giá trị.
                      ref.read(counterProvider.notifier).state++;
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tăng số'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    onPressed: () {
                      /// Reset giá trị về 0 bằng cách gán trực tiếp vào .state
                      ref.read(counterProvider.notifier).state = 0;
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Phần 2: Demo FutureProvider (Async Data)
            _buildSectionTitle(context, '2. FutureProvider (Dữ liệu API)'),
            
            /// SwitchListTile để bạn có thể chủ động bật/tắt lỗi khi thuyết trình.
            /// Khi gạt sang true, userProvider sẽ nhảy vào trạng thái error().
            SwitchListTile(
              title: const Text('Giả lập lỗi kết nối'),
              subtitle: const Text('Bật để xem trạng thái error()'),
              value: ref.watch(simulateErrorProvider),
              onChanged: (value) {
                // Cập nhật giá trị cho provider giả lập lỗi
                ref.read(simulateErrorProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(15),
              ),
              child: asyncUser.when(
                /// Quan trọng: skipLoadingOnRefresh: false giúp ép UI hiển thị trạng thái loading 
                /// mỗi khi chúng ta nhấn nút "Tải lại dữ liệu", giúp bài thuyết trình trực quan hơn.
                skipLoadingOnRefresh: false,

                /// Trạng thái khi đang tải (Loading)
                loading: () => const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Đang tải dữ liệu từ API giả lập...'),
                    ],
                  ),
                ),
                /// Trạng thái khi có lỗi (Error)
                error: (err, stack) => Column(
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.red),
                    const SizedBox(height: 10),
                    Text(
                      '$err',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                /// Trạng thái khi đã có dữ liệu (Data)
                data: (data) => Column(
                  children: [
                    const Icon(Icons.cloud_done, size: 50, color: Colors.green),
                    const SizedBox(height: 10),
                    Text(
                      data,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  /// Làm mới (refresh) FutureProvider để gọi lại API
                  ref.invalidate(userProvider);
                },
                icon: const Icon(Icons.sync),
                label: const Text('Tải lại dữ liệu'),
              ),
            ),
            
            const SizedBox(height: 40),
            const Divider(),
            const Center(
              child: Text(
                'Riverpod Demo',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Cộng 1',
        onPressed: () => ref.read(counterProvider.notifier).state++,
        child: const Icon(Icons.plus_one),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
    );
  }
}
