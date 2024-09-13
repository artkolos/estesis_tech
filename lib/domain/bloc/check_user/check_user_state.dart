part of 'check_user_cubit.dart';

@freezed
class CheckUserState with _$CheckUserState {
  const factory CheckUserState.initial() = _Initital;

  const factory CheckUserState.complete({
    User? user,
  }) = _Complete;
}
