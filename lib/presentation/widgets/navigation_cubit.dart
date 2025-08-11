import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  final PageController pageController = PageController();

  NavigationCubit() : super(0);

  void setPage(int index) {
    emit(index);
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) => emit(index);

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
