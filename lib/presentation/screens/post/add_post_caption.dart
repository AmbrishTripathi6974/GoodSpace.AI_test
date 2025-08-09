import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/add_post/add_post_bloc.dart';
import '../../../bloc/add_post/add_post_event.dart';
import '../../../bloc/add_post/add_post_state.dart';

class AddPostCaption extends StatelessWidget {
  final File file;
  final captionController = TextEditingController();

  AddPostCaption({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => AddPostBloc(),
      child: BlocConsumer<AddPostBloc, AddPostState>(
        listener: (context, state) {
          if (state is AddPostSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Post uploaded successfully!")),
            );
            Navigator.pop(context); // Go back after success
          } else if (state is AddPostFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Add New Post',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: state is! AddPostLoading
                          ? () {
                              context.read<AddPostBloc>().add(
                                    AddPostSubmitted(
                                      file: file,
                                      caption: captionController.text.trim(),
                                    ),
                                  );
                            }
                          : null,
                      child: Text(
                        'Share',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: state is AddPostLoading
                              ? Colors.grey
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(file),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: captionController,
                            decoration: const InputDecoration(
                              hintText: "Write post caption here...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state is AddPostLoading)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
