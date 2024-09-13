import 'dart:async';

import 'package:estesis_tech/domain/repository/auth_repository.dart';
import 'package:estesis_tech/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this.authRepository,
    this.userRepository,
  ) : super(const AuthState.initial()) {
    on(_onMap);
  }

  final AuthRepository authRepository;
  final UserRepository userRepository;

  FutureOr<void> _onMap(AuthEvent mainEvent, Emitter<AuthState> emit) =>
      mainEvent.map(
        register: (event) => _onRegister(event, emit),
        logIn: (event) => _onLogIn(event, emit),
        logout: (event) => _logout(event, emit),
      );

  Future<void> _onRegister(_Register event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final email = event.email;
        final user = await authRepository.singUp(
          event.name,
          event.email,
          event.password,
        );
        await userRepository.saveUser(user);
        await authRepository.signIn(email, event.password);
        emit(const AuthState.success());
    } catch (e, _) {
      emit(
        AuthState.error(errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onLogIn(_LogIn event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await authRepository.signIn(event.email, event.password);

      final user = await userRepository.getUser(event.email, event.password);

      await userRepository.saveUser(user);
      emit(const AuthState.success());
    } catch (e, _) {
      emit(AuthState.error(errorMessage: e.toString()));
    }
  }

  Future<void> _logout(_Logout event, Emitter<AuthState> emit) async {
    await authRepository.logout();
    emit(const AuthState.logoutSuccess());
  }
}
