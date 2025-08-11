abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {
  final String? userId;

  LoadProfileEvent({this.userId});
}
