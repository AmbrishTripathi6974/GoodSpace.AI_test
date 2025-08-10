import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object?> get props => [];
}

class FetchMediaEvent extends CreatePostEvent {}

class RetryFetchMediaEvent extends CreatePostEvent {}

class SelectMediaEvent extends CreatePostEvent {
  final int index;
  final AssetEntity selectedAsset;

  const SelectMediaEvent(this.index, this.selectedAsset);

  @override
  List<Object?> get props => [index, selectedAsset];
}
