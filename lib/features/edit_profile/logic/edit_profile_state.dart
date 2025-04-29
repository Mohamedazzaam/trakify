part of 'edit_profile_cubit.dart';

abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final String message;
  EditProfileSuccess(this.message);
}

class EditProfileFailure extends EditProfileState {
  final String errorMessage;
  EditProfileFailure(this.errorMessage);
}

class UploadProfileImage extends EditProfileState {
  final XFile image;
  UploadProfileImage({required this.image});
}
