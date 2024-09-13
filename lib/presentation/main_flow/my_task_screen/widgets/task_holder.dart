import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/domain/bloc/tasks/tasks_bloc.dart';
import 'package:estesis_tech/domain/model/task/task.dart';
import 'package:estesis_tech/gen/assets.gen.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:estesis_tech/presentation/design/widgets/app_checkbox.dart';
import 'package:estesis_tech/presentation/design/widgets/tap_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class TaskHolder extends StatefulWidget {
  const TaskHolder({
    super.key,
    required this.onChanged,
    required this.task,
  });

  final Function(bool value) onChanged;
  final Task task;

  @override
  State<TaskHolder> createState() => _TaskHolderState();
}

class _TaskHolderState extends State<TaskHolder> with TickerProviderStateMixin {
  late final AnimationController _removeAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 250,
    ),
  );
  late final AnimationController _doneAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 250,
    ),
  );

  late final Animation<Offset> _removeSlideAnimation =
      _removeAnimationController.drive(
    Tween(
      begin: const Offset(0, 0),
      end: Offset(-0.2.w, 0),
    ),
  );

  late final Animation<Offset> _doneSlideAnimation =
      _doneAnimationController.drive(
    Tween(
      begin: const Offset(0, 0),
      end: Offset(0.2.w, 0),
    ),
  );

  late final ValueNotifier<bool> _isDoneNotifier =
      ValueNotifier(widget.task.isDone);

  @override
  void dispose() {
    _removeAnimationController.dispose();
    _isDoneNotifier.dispose();
    _doneAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100.w,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                horizontal: 26.w,
                vertical: 25.h,
              ),
              decoration: BoxDecoration(
                  color: context.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(16)),
              child: TapAnimation(
                onTap: () => context.read<TasksBloc>().add(
                      TasksEvent.updateTask(
                        task: widget.task,
                      ),
                    ),
                child: Icon(
                  Icons.check,
                  color: context.colorScheme.onError,
                ),
              ),
            ),
            Container(
              width: 100.w,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(
                horizontal: 26.w,
                vertical: 25.h,
              ),
              decoration: BoxDecoration(
                  color: context.colorScheme.error,
                  borderRadius: BorderRadius.circular(16)),
              child: TapAnimation(
                onTap: () => context.read<TasksBloc>().add(
                      TasksEvent.removeTask(
                        taskSid: widget.task.sid,
                      ),
                    ),
                child: SvgPicture.asset(
                  Assets.icons.trashIcon,
                ),
              ),
            )
          ],
        ),
        SlideTransition(
          position: _doneSlideAnimation,
          child: SlideTransition(
            position: _removeSlideAnimation,
            child: GestureDetector(
              onTap: () {
                _removeAnimationController.reverse();
                _doneAnimationController.reverse();
              },
              onPanUpdate: (details) {
                if (details.delta.dx > 0.7) {
                  if (_removeSlideAnimation.isCompleted) {
                    _removeAnimationController.reverse();
                    return;
                  }
                  _doneAnimationController.forward();
                } else if (details.delta.dx < -0.7) {
                  if (_doneSlideAnimation.isCompleted) {
                    _doneAnimationController.reverse();
                    return;
                  }
                  _removeAnimationController.forward();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 16.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                  border: Border.all(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ValueListenableBuilder(
                            valueListenable: _isDoneNotifier,
                            builder: (context, isDone, _) {
                              return AppCheckbox(
                                onChanged: (value) {
                                  _isDoneNotifier.value = value;
                                },
                                currentValue: isDone,
                              );
                            }),
                        Gap(5.w),
                        Text(
                          widget.task.title,
                          style: TextStyle(
                            fontFamily: FontFamily.poppins,
                            fontSize: 14.sp,
                            decoration: widget.task.isDone
                                ? TextDecoration.lineThrough
                                : null,
                            fontWeight: FontWeight.w400,
                            color: context.colorScheme.onSecondary,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const Spacer(),
                        Icon(
                          Icons.info_outline,
                          color: context.colorScheme.secondary,
                          size: 15,
                        ),
                        Gap(45.w),
                      ],
                    ),
                    Gap(7.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Gap(10.w),
                        SvgPicture.asset(
                          Assets.icons.tagIcon,
                          width: 12,
                          height: 12,
                        ),
                        Text(
                          widget.task.tag.name,
                          style: TextStyle(
                            color: context.colorScheme.surface,
                            fontFamily: FontFamily.poppins,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Gap(5.w),
                        if (widget.task.finishAt != null &&
                            !widget.task.isDone &&
                            (DateTime.tryParse(
                                  widget.task.finishAt ?? '',
                                )!
                                    .compareTo(DateTime.now())) <
                                0)
                          Text(
                            DateFormat('d MMMM HH:mm', 'ru_RU').format(
                                DateTime.tryParse(widget.task.finishAt!)!),
                            style: TextStyle(
                              color: context.colorScheme.error,
                              fontFamily: FontFamily.poppins,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
