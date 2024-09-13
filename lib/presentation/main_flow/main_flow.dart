import 'package:auto_route/auto_route.dart';
import 'package:estesis_tech/domain/bloc/auth/auth_bloc.dart';
import 'package:estesis_tech/domain/bloc/tags/tags_bloc.dart';
import 'package:estesis_tech/domain/bloc/tasks/tasks_bloc.dart';
import 'package:estesis_tech/presentation/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';

@RoutePage(name: 'MainFlowRoute')
class MainFlow extends StatelessWidget {
  const MainFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt.get<TasksBloc>()),
        BlocProvider.value(value: getIt.get<TagsBloc>()),
        BlocProvider.value(value: getIt.get<AuthBloc>()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            state.mapOrNull(
              logoutSuccess: (state) => context.replaceRoute(
                const AuthFlowRoute(),
              ),
            );
          },
          child: const AutoRouter()),
    );
  }
}
