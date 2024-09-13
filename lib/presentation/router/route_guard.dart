import 'package:auto_route/auto_route.dart';
import 'package:estesis_tech/domain/bloc/check_user/check_user_cubit.dart';
import 'package:estesis_tech/domain/repository/user_repository.dart';
import 'package:estesis_tech/presentation/router/router.gr.dart';

class RouteGuard extends AutoRouteGuard {
  final CheckUserCubit checkUserCubit;

  RouteGuard(this.checkUserCubit);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    checkUserCubit.checkUser();
    final state = checkUserCubit.state.mapOrNull(
      complete: (user) => user,
    );
    if (state?.user != null) {
      resolver.next(true);
    } else {
      router.push(const AuthFlowRoute());
    }
  }
}
