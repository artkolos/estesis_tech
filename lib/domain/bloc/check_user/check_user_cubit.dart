import 'package:bloc/bloc.dart';
import 'package:estesis_tech/domain/model/user/user.dart';
import 'package:estesis_tech/domain/repository/user_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'check_user_cubit.freezed.dart';

part 'check_user_state.dart';

@injectable
class CheckUserCubit extends Cubit<CheckUserState> {
  CheckUserCubit(this.userRepository) : super(const CheckUserState.initial()) {
    checkUser();
  }

  final UserRepository userRepository;

  void checkUser() {
    print('checkUser ${userRepository.getUserFromStorage()}');
    emit(
      CheckUserState.complete(
        user: userRepository.getUserFromStorage(),
      ),
    );
  }
}
