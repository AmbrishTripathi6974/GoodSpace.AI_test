import 'package:equatable/equatable.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];
}

class FetchMediaEvent extends CreatePostEvent {}

class RetryFetchMediaEvent extends CreatePostEvent {}

class SelectMediaEvent extends CreatePostEvent {
  final int index;

  const SelectMediaEvent(this.index);

  @override
  List<Object> get props => [index];
}