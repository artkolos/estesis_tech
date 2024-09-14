import 'package:auto_route/auto_route.dart';
import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/core/extensions/locale_ext.dart';
import 'package:estesis_tech/gen/assets.gen.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:estesis_tech/presentation/design/widgets/app_button.dart';
import 'package:estesis_tech/presentation/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.red,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Assets.images.background
                  .image(fit: BoxFit.fitWidth, width: double.infinity),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 63.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                    color: context.colorScheme.onError,
                  ),
                  child: Column(
                    children: [
                      Text(
                        context.locale.taska,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 46.sp,
                          fontFamily: FontFamily.pollerOne,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      Gap(16.h),
                      Text(
                        context.locale.presonalTaskTracker,
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontSize: 37.sp,
                          fontWeight: FontWeight.w700,
                          color: context.colorScheme.tertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Gap(10.h),
                      Text(
                        context.locale.taskaSlogan,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          fontFamily: FontFamily.poppins,
                          color: context.colorScheme.surface,
                        ),
                      ),
                      Gap(66.h),
                      AppButton(
                        onTap: () => context.pushRoute(const MainFlowRoute()),
                        title: context.locale.continueText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
