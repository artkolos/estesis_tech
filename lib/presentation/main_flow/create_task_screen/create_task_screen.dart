import 'package:auto_route/auto_route.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/core/extensions/locale_ext.dart';
import 'package:estesis_tech/core/extensions/priority_ext.dart';
import 'package:estesis_tech/core/extensions/string_ext.dart';
import 'package:estesis_tech/domain/bloc/tags/tags_bloc.dart';
import 'package:estesis_tech/domain/bloc/tasks/tasks_bloc.dart';
import 'package:estesis_tech/domain/model/enum/priority.dart';
import 'package:estesis_tech/domain/model/tag/tag.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:estesis_tech/presentation/auth_flow/widgets/app_back_button.dart';
import 'package:estesis_tech/presentation/design/widgets/app_button.dart';
import 'package:estesis_tech/presentation/design/widgets/app_checkbox.dart';
import 'package:estesis_tech/presentation/main_flow/create_task_screen/widgets/choose_priority.dart';
import 'package:estesis_tech/presentation/main_flow/create_task_screen/widgets/create_task_text_field.dart';
import 'package:estesis_tech/presentation/main_flow/create_task_screen/widgets/date_time_field.dart';
import 'package:estesis_tech/presentation/main_flow/create_task_screen/widgets/tags_dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

@RoutePage()
class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _nameTaskController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final ValueNotifier<List<DateTime?>?> _dateNotifier = ValueNotifier(null);
  final ValueNotifier<TimeOfDay?> _timeNotifyer = ValueNotifier(null);
  final ValueNotifier<Priority> _priorityNotifier = ValueNotifier(Priority.low);
  final ValueNotifier<bool> _isThereDeadlineNotifier = ValueNotifier(false);
  Tag? _tag;

  @override
  void dispose() {
    _priorityNotifier.dispose();
    _isThereDeadlineNotifier.dispose();
    _timeNotifyer.dispose();
    _dateNotifier.dispose();
    _nameTaskController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<TagsBloc>().add(const TagsEvent.getTags());
  }

  void _onTapTime() async {
    _timeNotifyer.value = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(
        hour: 0,
        minute: 0,
      ),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
  }

  void _onTapDate() async {
    _dateNotifier.value = await showCalendarDatePicker2Dialog(
      context: context,
      dialogBackgroundColor: Colors.white,
      borderRadius: BorderRadius.circular(15),
      config: CalendarDatePicker2WithActionButtonsConfig(
        customModePickerIcon: const SizedBox(),
        cancelButton: const SizedBox(),
        calendarType: CalendarDatePicker2Type.single,
        modePickerBuilder: ({required monthDate, isMonthPicker}) =>
            isMonthPicker ?? false
                ? Padding(
                    padding: EdgeInsets.only(
                      top: 15.h,
                    ),
                    child: Text(
                      DateFormat('MMMM', 'ru_RU')
                          .format(monthDate)
                          .capitalize(),
                      style: TextStyle(
                        fontFamily: FontFamily.poppins,
                        fontSize: 14,
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : const SizedBox(),
        // okButton: const SizedBox(),
        calendarViewMode: CalendarDatePicker2Mode.day,
        centerAlignModePicker: true,
      ),
      dialogSize: const Size(
        263,
        300,
      ),
    );
  }

  void _onTapCreate() {
    final date = _dateNotifier.value?.first;
    final time = _timeNotifyer.value;
    final finishAt = DateTime(
      date?.year ?? 1970,
      date?.month ?? 1,
      date?.day ?? 1,
      time?.hour ?? 0,
      time?.minute ?? 0,
    );
    context.read<TasksBloc>().add(
          TasksEvent.createTask(
            tagSid: _tag?.sid ?? '',
            title: _nameTaskController.text,
            text: _noteController.text,
            finishAt: finishAt.toString(),
            priority: _priorityNotifier.value.priorityToIndex(),
          ),
        );
    context.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: const SizedBox(),
        toolbarHeight: 60.h,
        flexibleSpace: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const AppBackButton(),
                Gap(50.w),
                Text(
                  context.locale.createTask,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    fontFamily: FontFamily.poppins,
                    color: context.colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
        ),
        child: ListView(
          padding: EdgeInsets.only(
            bottom: 60.h,
          ),
          children: [
            Gap(16.h),
            CreateTaskTextField(
              title: context.locale.taskName,
              hint: context.locale.taskName,
              controller: _nameTaskController,
            ),
            Gap(16.h),
            CreateTaskTextField(
              title: context.locale.note,
              hint: context.locale.textNote,
              controller: _noteController,
            ),
            Gap(16.h),
            BlocBuilder<TagsBloc, TagsState>(
              builder: (context, state) {
                return TagsDropdownButton(
                  title: context.locale.chooseTag,
                  tags: state.map(
                    initial: (_) => [],
                    loading: (_) => [],
                    success: (state) => state.tags,
                  ),
                  onSaved: (value) => _tag = value,
                );
              },
            ),
            Gap(16.h),
            Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: _dateNotifier,
                  builder: (context, dateTimes, _) {
                    return DateTimeField(
                      onTap: _onTapDate,
                      title: context.locale.date,
                      value: (dateTimes != null && dateTimes.isNotEmpty)
                          ? DateFormat('dd.MM.yyyy').format(dateTimes.first!)
                          : context.locale.date,
                    );
                  },
                ),
                Gap(30.w),
                ValueListenableBuilder(
                  valueListenable: _timeNotifyer,
                  builder: (context, time, _) {
                    return DateTimeField(
                      onTap: _onTapTime,
                      title: context.locale.time,
                      value: time != null
                          ? '${time.hour}:${time.minute}'
                          : context.locale.time,
                    );
                  },
                ),
              ],
            ),
            Gap(16.h),
            Row(
              children: [
                AppCheckbox(
                  size: 27.75.w,
                  onChanged: (value) => _isThereDeadlineNotifier.value = value,
                  currentValue: _isThereDeadlineNotifier.value,
                ),
                Gap(14.w),
                Text(
                  context.locale.isThereDeadline,
                  style: TextStyle(
                    fontFamily: FontFamily.poppins,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: context.colorScheme.surface,
                  ),
                ),
              ],
            ),
            Gap(16.h),
            ValueListenableBuilder(
              valueListenable: _isThereDeadlineNotifier,
              builder: (context, isThereDeadline, _) => isThereDeadline
                  ? Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: _dateNotifier,
                          builder: (context, dateTimes, _) {
                            return DateTimeField(
                              onTap: _onTapDate,
                              title: context.locale.completeBy,
                              value: (dateTimes != null && dateTimes.isNotEmpty)
                                  ? DateFormat('dd.MM.yyyy')
                                      .format(dateTimes.first!)
                                  : context.locale.date,
                            );
                          },
                        ),
                        Gap(30.w),
                        ValueListenableBuilder(
                          valueListenable: _timeNotifyer,
                          builder: (context, time, _) {
                            return DateTimeField(
                              onTap: _onTapTime,
                              title: context.locale.time,
                              value: time != null
                                  ? '${time.hour}:${time.minute}'
                                  : context.locale.time,
                            );
                          },
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
            Gap(16.h),
            ValueListenableBuilder(
              valueListenable: _priorityNotifier,
              builder: (context, priority, _) {
                return ChoosePriority(
                  onChanged: (value) {
                    _priorityNotifier.value = value;
                  },
                  currentValue: priority,
                );
              },
            ),
            Gap(30.h),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 79.w,
              ),
              child: AppButton(
                onTap: _onTapCreate,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
                title: context.locale.add,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
