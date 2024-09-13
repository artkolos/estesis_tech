import 'package:auto_route/auto_route.dart';
import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/core/extensions/locale_ext.dart';
import 'package:estesis_tech/domain/bloc/auth/auth_bloc.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:estesis_tech/presentation/auth_flow/widgets/app_back_button.dart';
import 'package:estesis_tech/presentation/design/widgets/app_button.dart';
import 'package:estesis_tech/presentation/design/widgets/app_text_button.dart';
import 'package:estesis_tech/presentation/design/widgets/app_text_field.dart';
import 'package:estesis_tech/presentation/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onTapLogIn() => context.navigateTo(const SignInRoute());

  void _onTapSignUp() {
    print('_onTapSignUp');
    context.read<AuthBloc>().add(
      AuthEvent.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: context.read<AuthBloc>(),
      listener: (context, state) {
        print('signUp listener');
        state.mapOrNull(
          success: (_) => context.replaceRoute(
            const MainFlowRoute(),
          ),
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 60.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppBackButton(),
                  Gap(66.w),
                  Text(
                    context.locale.signUp,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.poppins,
                      color: context.colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
              Gap(40.h),
              Text(
                context.locale.createAccount,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25.sp,
                  fontFamily: FontFamily.poppins,
                  color: context.colorScheme.onSecondary,
                ),
              ),
              Gap(12.h),
              Text(
                context.locale.fillInFields,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamily.poppins,
                  fontSize: 14.sp,
                  color: context.colorScheme.surface,
                ),
              ),
              Gap(64.h),
              AppTextField(
                controller: _nameController,
                hint: context.locale.inputName,
              ),
              Gap(30.h),
              AppTextField(
                controller: _emailController,
                hint: context.locale.inputEmail,
              ),
              Gap(30.h),
              AppTextField(
                obscureText: true,
                controller: _passwordController,
                hint: context.locale.inputPassword,
              ),
              Gap(30.h),
              AppButton(
                onTap: _onTapSignUp,
                title: context.locale.signUp,
              ),
              Gap(16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${context.locale.haveAccount} ',
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontSize: 14,
                      color: context.colorScheme.surface,
                    ),
                  ),
                  AppTextButton(
                    title: context.locale.logIn,
                    onTap: _onTapLogIn,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
