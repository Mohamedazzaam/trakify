part of 'profile_cubit.dart';

@immutable
sealed class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}

final class ChangePasswordSuccess extends ChangePasswordState {
  final String success;
  ChangePasswordSuccess({required this.success});
}

final class ChangePasswordLoading extends ChangePasswordState {}

final class ChangePasswordFailure extends ChangePasswordState {
  final String errorMessage;
  ChangePasswordFailure({required this.errorMessage});
}
