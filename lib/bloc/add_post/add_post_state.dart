import 'package:equatable/equatable.dart';

abstract class AddPostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddPostInitial extends AddPostState {}

class AddPostLoading extends AddPostState {}

class AddPostSuccess extends AddPostState {}

class AddPostFailure extends AddPostState {
  final String error;
  AddPostFailure(this.error);

  @override
  List<Object?> get props => [error];
}
