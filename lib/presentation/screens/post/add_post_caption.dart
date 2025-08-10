import 'dart:io';
import 'package:flutter/material.dart';
import 'package:good_space_test/services/storage.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/utils/image_compressor.dart';

class AddPostCaption extends StatefulWidget {
  final AssetEntity asset;

  const AddPostCaption({super.key, required this.asset});

  @override
  State<AddPostCaption> createState() => _AddPostCaptionState();
}

class _AddPostCaptionState extends State<AddPostCaption> {
  final caption = TextEditingController();
  File? file;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    final f = await widget.asset.file;
    if (f != null) {
      final compressedFile = await ImageCompressor.compressImage(f, quality: 70);
      if (mounted) {
        setState(() {
          file = compressedFile ?? f; // fallback if compression fails
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () async {
                  if (file == null) return;
                  String postUrl = await StorageMethod()
                      .uploadImageToStorage('post', file!);

                  print("Uploaded post URL: $postUrl");
                },
                child: Text(
                  'Share',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (file != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          image: DecorationImage(
                            image: FileImage(file!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: caption,
                          keyboardType: TextInputType.multiline,
                          maxLines: null, // grows with input
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            isCollapsed: true, // less vertical padding
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
