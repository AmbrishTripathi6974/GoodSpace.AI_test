import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AddPostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddPostSubmitted extends AddPostEvent {
  final File file;
  final String caption;

  AddPostSubmitted({required this.file, required this.caption});

  @override
  List<Object?> get props => [file, caption];
}
