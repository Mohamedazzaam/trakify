part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class GetProfleDataSuccess extends ProfileState {
  final UserModel userResponseModel;
  GetProfleDataSuccess({required this.userResponseModel});
}

final class GetProfleDataLoading extends ProfileState {}

final class GetProfleDataFailure extends ProfileState {
  final String errorMessage;
  GetProfleDataFailure({required this.errorMessage});
}
