import 'package:auto_route/auto_route.dart';
import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/core/extensions/locale_ext.dart';
import 'package:estesis_tech/domain/bloc/auth/auth_bloc.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:estesis_tech/injection.dart';
import 'package:estesis_tech/presentation/design/widgets/app_button.dart';
import 'package:estesis_tech/presentation/design/widgets/app_text_button.dart';
import 'package:estesis_tech/presentation/design/widgets/app_text_field.dart';
import 'package:estesis_tech/presentation/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isErrorNotifier = ValueNotifier(false);

  @override
  void dispose() {
    _isErrorNotifier.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onTapRegister() => context.pushRoute(
        const SignUpRoute(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: context.read<AuthBloc>(),
      listener: (context, state) {
        state.mapOrNull(
          success: (_) => context.replaceRoute(
            const MainFlowRoute(),
          ),
          loading: (_) => _isErrorNotifier.value = false,
          error: (_) => _isErrorNotifier.value = true,
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 60.h,
          ),
          child: ValueListenableBuilder(
              valueListenable: _isErrorNotifier,
              builder: (context, isError, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        context.locale.signIn,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: FontFamily.poppins,
                          color: context.colorScheme.onSecondary,
                        ),
                      ),
                    ),
                    Gap(40.h),
                    Text(
                      context.locale.welcome,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25.sp,
                        fontFamily: FontFamily.poppins,
                        color: context.colorScheme.onSecondary,
                      ),
                    ),
                    Gap(12.h),
                    Text(
                      context.locale.inputEmailAndPassword,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: FontFamily.poppins,
                        fontSize: 14.sp,
                        color: context.colorScheme.surface,
                      ),
                    ),
                    Gap(64.h),
                    AppTextField(
                      controller: _emailController,
                      hint: context.locale.inputEmail,
                    ),
                    if (isError) ...[
                      Gap(5.h),
                      Text(
                        'Не правильный логин или пароль',
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: context.colorScheme.error,
                        ),
                      )
                    ],
                    Gap(30.h),
                    AppTextField(
                      controller: _passwordController,
                      obscureText: true,
                      hint: context.locale.inputPassword,
                    ),
                    Gap(28.h),
                    AppButton(
                      onTap: () {
                        context.read<AuthBloc>().add(
                              AuthEvent.logIn(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ),
                            );
                      },
                      title: context.locale.signIn,
                    ),
                    Gap(37.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${context.locale.noAccount} ',
                          style: TextStyle(
                            fontFamily: FontFamily.poppins,
                            fontSize: 14,
                            color: context.colorScheme.surface,
                          ),
                        ),
                        AppTextButton(
                          title: context.locale.register,
                          onTap: _onTapRegister,
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
