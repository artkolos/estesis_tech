part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _AuthState;

  const factory AuthState.loading() = _Loading;

  const factory AuthState.success() = _Succcess;

  const factory AuthState.logoutSuccess() = _LogoutSuccess;

  const factory AuthState.error({
    required String errorMessage,
  }) = _Error;
}
