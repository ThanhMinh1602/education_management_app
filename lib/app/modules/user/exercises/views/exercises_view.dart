import 'package:blooket/app/modules/user/exercises/widgets/exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:get/get.dart';
// Import các widget con đã tách ở dưới
// import 'path/to/exercise_card.dart';

class ExercisesView extends StatefulWidget {
  const ExercisesView({super.key});

  @override
  State<ExercisesView> createState() => _ExercisesViewState();
}

class _ExercisesViewState extends State<ExercisesView> {
  @override
  Widget build(BuildContext context) {
    // Lấy chiều rộng màn hình
    double screenWidth = MediaQuery.of(context).size.width;

    // Tính toán số lượng cột: Mobile (2), Tablet (3-4), Desktop (5-6)
    int crossAxisCount = screenWidth < 600 ? 2 : (screenWidth < 1000 ? 4 : 6);

    // Tính toán tỷ lệ khung hình của Card để tránh bị quá dài hoặc quá ngắn
    double childAspectRatio = screenWidth < 600 ? 0.85 : 1.1;

    return Scaffold(
      backgroundColor: AppColor.secondary,
      appBar: CustomAppBar(
        title: 'Exercises',
        showBackButton: false,
        actions: [const _UserAvatar()],
      ),
      body: Center(
        // Căn giữa để trên màn hình lớn không bị lệch
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ), // Giới hạn chiều rộng tối đa cho Desktop
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Bài Tập',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: 10,
                  padding: const EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: childAspectRatio, // Giữ card cân đối
                  ),
                  itemBuilder: (context, index) {
                    return ExerciseCard(
                      level: 'SƠ CẤP',
                      range: '${index * 5 + 1} - ${(index + 1) * 5}',
                      onStart: () {
                        Get.toNamed('${Get.currentRoute}/$index');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget phụ: Avatar User trên AppBar
class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(
            'https://scontent.fdad1-3.fna.fbcdn.net/v/t39.30808-6/494509465_2058983121179955_7304127112377973386_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=7BjcgmSKAoMQ7kNvwHhbMrT&_nc_oc=AdlQGzqycZXoA-KdSefZXs5m07yJieVzf9XUfkgeeFjMdbh66i9HJilpvQyDfi01DPU&_nc_zt=23&_nc_ht=scontent.fdad1-3.fna&_nc_gid=B_8tnP0B4WhuD3q-ocVp6A&oh=00_AfmUfwydMZ16IGoqMe2__M7HM32OfVYGlOltf5DHq8xGXg&oe=6951D131',
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Hi, Sunni',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
