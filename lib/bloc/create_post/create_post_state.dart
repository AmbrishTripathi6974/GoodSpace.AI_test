import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object?> get props => [];
}

class CreatePostInitial extends CreatePostState {}

class CreatePostLoading extends CreatePostState {}


class CreatePostLoaded extends CreatePostState {
  final List<Widget> mediaList;
  final List<AssetEntity> assetList;
  final int currentIndex;

  const CreatePostLoaded({
    required this.mediaList,
    required this.assetList,
    required this.currentIndex,
  });

  AssetEntity get selectedAsset => assetList[currentIndex];

  CreatePostLoaded copyWith({
    List<Widget>? mediaList,
    List<AssetEntity>? assetList,
    int? currentIndex,
  }) {
    return CreatePostLoaded(
      mediaList: mediaList ?? this.mediaList,
      assetList: assetList ?? this.assetList,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [mediaList, assetList, currentIndex];
}


class CreatePostEmpty extends CreatePostState {}

class CreatePostError extends CreatePostState {
  final String message;

  const CreatePostError(this.message);

  @override
  List<Object> get props => [message];
}

class CreatePostPermissionDenied extends CreatePostState {}
