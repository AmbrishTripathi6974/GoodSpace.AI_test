import 'package:flutter_bloc/flutter_bloc.dart';

class HeartAnimationCubit extends Cubit<bool> {
  HeartAnimationCubit() : super(false);

  void triggerAnimation() {
    emit(true);
    Future.delayed(const Duration(milliseconds: 800), () {
      emit(false);
    });
  }
}
