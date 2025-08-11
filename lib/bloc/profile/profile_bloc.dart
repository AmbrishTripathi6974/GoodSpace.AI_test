import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/firebase_auth.dart';
import 'profile_event.dart';
import 'profile_state.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthenticationService authService;

  ProfileBloc({required this.authService}) : super(ProfileInitial()) {
    on<LoadProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await authService.getCurrentUser();
        if (user == null) {
          emit(ProfileError("User not logged in"));
          return;
        }
        emit(ProfileLoaded(user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
