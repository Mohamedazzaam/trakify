import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakify/core/widgets/custom_snack_bar.dart';
import 'package:trakify/features/profile/logic/profile_cubit.dart';
import 'package:trakify/features/profile/ui/widgets/user_header.dart';
import 'package:trakify/features/profile/ui/widgets/user_header_loading.dart';

class GetUserDataBlocBuilder extends StatelessWidget {
  const GetUserDataBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is GetProfleDataLoading) {
          return const UserHeaderLoading();
        }
        if (state is GetProfleDataSuccess) {
          return UserHeader(userResponseModel: state.userResponseModel);
        }
        if (state is GetProfleDataFailure) {
          customSnackBar(context, state.errorMessage);
          return const SizedBox.shrink();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
