import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_space_test/presentation/screens/explore/explore_screen.dart';
import 'package:good_space_test/presentation/screens/feed/feed_screen.dart';
import 'package:good_space_test/presentation/screens/post/create_post_screen.dart';
import '../../widgets/naviagtion_visivbility_cubit.dart';
import '../../widgets/navigation_cubit.dart';
import '../profile/profile_screen.dart';

class NavigationsScreen extends StatelessWidget {
  const NavigationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => NavBarVisibilityCubit()),
      ],
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          final navCubit = context.read<NavigationCubit>();

          return Scaffold(
            extendBody: true,
            bottomNavigationBar: BlocBuilder<NavBarVisibilityCubit, bool>(
              builder: (context, isVisible) {
                return AnimatedSlide(
                  offset: isVisible ? Offset.zero : const Offset(0, 1),
                  duration: const Duration(milliseconds: 200),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    selectedItemColor: Colors.black,
                    unselectedItemColor: Colors.grey,
                    currentIndex: currentIndex,
                    onTap: navCubit.setPage,
                    items: [
                      const BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                      const BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
                      BottomNavigationBarItem(
                        icon: Image.asset('assets/images/instagram-reels-icon.png', height: 20),
                        label: '',
                      ),
                      const BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
                    ],
                  ),
                );
              },
            ),
            body: PageView(
              controller: navCubit.pageController,
              onPageChanged: navCubit.onPageChanged,
              children: [
                FeedScreen(),
                ExploreScreen(),
                CreatePostScreen(),
                ProfileScreen(),
              ],
            ),
          );
        },
      ),
    );
  }
}
