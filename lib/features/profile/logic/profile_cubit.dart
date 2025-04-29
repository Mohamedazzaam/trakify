import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakify/features/login/data/models/user_model.dart';

import '../data/repo/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.profileRepo) : super(ProfileInitial());
  final ProfileRepo profileRepo;

  getProfileData() async {
    emit(GetProfleDataLoading());
    final profileResponse = await profileRepo.getUserProfile();

    profileResponse.fold(
      (errorMessage) => emit(GetProfleDataFailure(errorMessage: errorMessage)),
      (userResponseModel) =>
          emit(GetProfleDataSuccess(userResponseModel: userResponseModel)),
    );
  }
}
