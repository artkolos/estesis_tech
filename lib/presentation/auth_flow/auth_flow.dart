import 'package:auto_route/auto_route.dart';
import 'package:estesis_tech/domain/bloc/auth/auth_bloc.dart';
import 'package:estesis_tech/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage(name: 'AuthFlowRoute')
class AuthFlow extends StatelessWidget {
  const AuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<AuthBloc>(),
      child: const AutoRouter(),
    );
  }
}
