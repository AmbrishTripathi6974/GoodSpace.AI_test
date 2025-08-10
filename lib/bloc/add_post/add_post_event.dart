import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AddPostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddPostSubmitted extends AddPostEvent {
  final File image;
  final String caption;

  AddPostSubmitted({required this.image, required this.caption});

  @override
  List<Object?> get props => [image, caption];
}
