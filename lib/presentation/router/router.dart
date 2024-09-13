import 'package:auto_route/auto_route.dart';
import 'package:estesis_tech/domain/bloc/check_user/check_user_cubit.dart';
import 'package:estesis_tech/presentation/router/route_guard.dart';

import 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final CheckUserCubit checkUserCubit;

  AppRouter(this.checkUserCubit);

  @override
  List<AutoRoute> get routes => [
        AdaptiveRoute(
          page: SplashRoute.page,
          initial: true,
        ),
        AdaptiveRoute(
          page: AuthFlowRoute.page,
          children: [
            AdaptiveRoute(
              page: SignInRoute.page,
              initial: true,
            ),
            AdaptiveRoute(
              page: SignUpRoute.page,
            ),
          ],
        ),
        AdaptiveRoute(
          page: MainFlowRoute.page,
          guards: [
            RouteGuard(checkUserCubit),
          ],
          children: [
            AdaptiveRoute(
              initial: true,
              page: MyTaskRoute.page,
            ),
            AdaptiveRoute(
              page: CreateTaskRoute.page,
            )
          ],
        ),
      ];
}
