import 'package:flutter_bloc/flutter_bloc.dart';

class NavBarVisibilityCubit extends Cubit<bool> {
  NavBarVisibilityCubit() : super(true);

  void show() => emit(true);
  void hide() => emit(false);
}
