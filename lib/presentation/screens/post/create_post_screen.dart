// create_post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_space_test/core/utils/helper_function.dart';
import 'package:good_space_test/presentation/screens/post/add_post_caption.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../bloc/create_post/create_post_bloc.dart';
import '../../../bloc/create_post/create_post_event.dart';
import '../../../bloc/create_post/create_post_state.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePostBloc()..add(FetchMediaEvent()),
      child: const CreatePostView(),
    );
  }
}

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
            'This app needs access to your photos to continue. Please grant permission in your device settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              PhotoManager.openSetting();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = THelperFunctions.screenSize(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'New Post',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  final state = context.read<CreatePostBloc>().state;
                  if (state is CreatePostLoaded) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            AddPostCaption(asset: state.selectedAsset),
                      ),
                    );
                  }
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<CreatePostBloc, CreatePostState>(
          listener: (context, state) {
            if (state is CreatePostPermissionDenied) {
              _showPermissionDialog(context);
            }
          },
          builder: (context, state) {
            if (state is CreatePostLoading || state is CreatePostInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CreatePostError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading photos',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<CreatePostBloc>()
                            .add(RetryFetchMediaEvent());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is CreatePostEmpty ||
                state is CreatePostPermissionDenied) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.photo_library_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state is CreatePostPermissionDenied
                          ? 'Permission denied'
                          : 'No photos found',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state is CreatePostPermissionDenied
                          ? 'Please grant permission to access your photos'
                          : 'Make sure you have photos in your gallery',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (state is CreatePostPermissionDenied) {
                          PhotoManager.openSetting();
                        } else {
                          context
                              .read<CreatePostBloc>()
                              .add(RetryFetchMediaEvent());
                        }
                      },
                      child: Text(state is CreatePostPermissionDenied
                          ? 'Open Settings'
                          : 'Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is CreatePostLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Selected media preview
                    SizedBox(
                      height: size.height * 0.4,
                      width: double.infinity,
                      child: state.mediaList.isNotEmpty
                          ? state.mediaList[state.currentIndex]
                          : Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.photo,
                                    size: 64, color: Colors.grey),
                              ),
                            ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Recent',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    // Media grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.mediaList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            final asset = state.assetList[index];
                            context
                                .read<CreatePostBloc>()
                                .add(SelectMediaEvent(index, asset));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: state.currentIndex == index
                                  ? Border.all(color: Colors.blue, width: 3)
                                  : null,
                            ),
                            child: state.mediaList[index],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
