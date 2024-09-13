import 'package:estesis_tech/domain/bloc/auth/auth_bloc.dart';
import 'package:estesis_tech/domain/bloc/check_user/check_user_cubit.dart';
import 'package:estesis_tech/injection.dart';
import 'package:estesis_tech/presentation/design/theme/theme.dart';
import 'package:estesis_tech/presentation/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late final AppRouter _appRouter;
  late final CheckUserCubit _checkUserCubit;

  @override
  void dispose() {
    _appRouter.dispose();
    _checkUserCubit.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkUserCubit = getIt<CheckUserCubit>();
    _appRouter = AppRouter(_checkUserCubit);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
