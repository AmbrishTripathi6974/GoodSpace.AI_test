import 'package:equatable/equatable.dart';

abstract class ExploreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadExplorePosts extends ExploreEvent {}

class SearchUsers extends ExploreEvent {
  final String query;
  SearchUsers(this.query);

  @override
  List<Object?> get props => [query];
}
