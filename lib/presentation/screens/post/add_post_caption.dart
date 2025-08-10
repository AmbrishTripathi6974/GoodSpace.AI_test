// views/add_post_caption.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../bloc/add_post/add_post_bloc.dart';
import '../../../bloc/add_post/add_post_event.dart';
import '../../../bloc/add_post/add_post_state.dart';
import '../../../core/utils/image_compressor.dart';
import '../../../repository/post_repository.dart';
import '../../../services/firestore.dart';
import '../../../services/storage.dart';

class AddPostCaption extends StatelessWidget {
  final AssetEntity asset;
  final TextEditingController captionController = TextEditingController();

  AddPostCaption({super.key, required this.asset});

  Future<File?> _prepareImage() async {
    final file = await asset.file;
    if (file != null) {
      return await ImageCompressor.compressImage(file, quality: 70) ?? file;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: _prepareImage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final file = snapshot.data!;

        return BlocProvider(
          create: (_) => AddPostBloc(
            postRepository: PostRepository(
              firestoreService: FirebaseFirestoreService(),
              storageService: FirebaseStorageService(),
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Add New Post", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              actions: [
                BlocConsumer<AddPostBloc, AddPostState>(
                  listener: (context, state) {
                    if (state is AddPostSuccess) {
                      Navigator.pop(context);
                    } else if (state is AddPostFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AddPostLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child: CircularProgressIndicator()),
                      );
                    }
                    return TextButton(
                      onPressed: () {
                        context.read<AddPostBloc>().add(
                              AddPostSubmitted(
                                image: file,
                                caption: captionController.text.trim(),
                              ),
                            );
                      },
                      child: const Text(
                        "Share",
                        style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.file(file, width: 65, height: 65, fit: BoxFit.cover),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: captionController,
                      decoration: const InputDecoration(
                        hintText: "Write a caption...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
