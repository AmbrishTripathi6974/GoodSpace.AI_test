import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object?> get props => [];
}

class CreatePostInitial extends CreatePostState {}

class CreatePostLoading extends CreatePostState {}

class CreatePostLoaded extends CreatePostState {
  final List<Widget> mediaList;
  final List<File> filePaths;
  final File? selectedFile;
  final int currentIndex;

  const CreatePostLoaded({
    required this.mediaList,
    required this.filePaths,
    this.selectedFile,
    required this.currentIndex,
  });

  @override
  List<Object?> get props => [mediaList, filePaths, selectedFile, currentIndex];

  CreatePostLoaded copyWith({
    List<Widget>? mediaList,
    List<File>? filePaths,
    File? selectedFile,
    int? currentIndex,
  }) {
    return CreatePostLoaded(
      mediaList: mediaList ?? this.mediaList,
      filePaths: filePaths ?? this.filePaths,
      selectedFile: selectedFile ?? this.selectedFile,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class CreatePostEmpty extends CreatePostState {}

class CreatePostError extends CreatePostState {
  final String message;

  const CreatePostError(this.message);

  @override
  List<Object> get props => [message];
}

class CreatePostPermissionDenied extends CreatePostState {}
