part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.register({
    required String name,
    required String email,
    required String password,
  }) = _Register;

  const factory AuthEvent.logIn({
    required String email,
    required String password,
  }) = _LogIn;

  const factory AuthEvent.logout() =_Logout;
}
