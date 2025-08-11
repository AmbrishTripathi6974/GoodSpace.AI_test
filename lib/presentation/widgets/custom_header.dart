import 'package:flutter/material.dart';
import 'package:good_space_test/presentation/screens/post/create_post_screen.dart';
import 'package:good_space_test/presentation/screens/profile/profile_screen.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/auth/auth_bloc.dart';
// import '../../bloc/auth/auth_event.dart';
// import '../screens/auth/login_screen.dart';

class CustomFeedSliverAppBar extends StatelessWidget {
  const CustomFeedSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      floating: true,
      snap: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 55,
            child: Image.asset(
              'assets/text_logo.png',
              fit: BoxFit.contain,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite_border_rounded,
                  color: theme.appBarTheme.foregroundColor ?? Colors.black,
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                // onPressed: () {
                //   context.read<AuthBloc>().add(AuthLoggedOut());
                //   Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (_) => LoginScreen()),
                //     (route) => false,
                //   );
                // },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Image.asset(
                  'assets/images/send.jpg',
                  height: 22,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreatePostScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
