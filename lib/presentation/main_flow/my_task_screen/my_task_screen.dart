import 'package:auto_route/auto_route.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:estesis_tech/core/extensions/color_scheme_ext.dart';
import 'package:estesis_tech/core/extensions/locale_ext.dart';
import 'package:estesis_tech/core/extensions/string_ext.dart';
import 'package:estesis_tech/core/extensions/tags_ext.dart';
import 'package:estesis_tech/domain/bloc/auth/auth_bloc.dart';
import 'package:estesis_tech/domain/bloc/tasks/tasks_bloc.dart';
import 'package:estesis_tech/domain/model/enum/tag_type.dart';
import 'package:estesis_tech/gen/assets.gen.dart';
import 'package:estesis_tech/gen/fonts.gen.dart';
import 'package:estesis_tech/presentation/auth_flow/widgets/app_back_button.dart';
import 'package:estesis_tech/presentation/design/widgets/app_icon_button.dart';
import 'package:estesis_tech/presentation/design/widgets/app_text_field.dart';
import 'package:estesis_tech/presentation/design/widgets/tap_animation.dart';
import 'package:estesis_tech/presentation/main_flow/my_task_screen/widgets/date_holder.dart';
import 'package:estesis_tech/presentation/main_flow/my_task_screen/widgets/tags_panel.dart';
import 'package:estesis_tech/presentation/main_flow/my_task_screen/widgets/task_holder.dart';
import 'package:estesis_tech/presentation/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:list_wheel_scroll_view_nls/list_wheel_scroll_view_nls.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({super.key});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(
    initialItem: 2,
  );
  final ValueNotifier<DateTime> _selectedDateNotifier =
      ValueNotifier(DateTime.now());

  final ValueNotifier<TagType> _tagTypeNotifier = ValueNotifier(TagType.all);

  final ValueNotifier<bool> _hasFocusNotifier = ValueNotifier(false);

  final FocusNode _focusNode = FocusNode();

  late final TasksBloc _tasksBloc = context.read<TasksBloc>();

  @override
  void dispose() {
    _hasFocusNotifier.dispose();
    _tasksBloc.close();
    _focusNode.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _generateDates();
    _tasksBloc.add(
      const TasksEvent.getTasks(
        isShowAllTasks: false,
      ),
    );
    _focusNode.addListener(_focusListener);
    _searchController.addListener(_textListener);
  }

  void _focusListener() {
    if (_focusNode.hasFocus) {
      _hasFocusNotifier.value = true;
    } else {
      _hasFocusNotifier.value = false;
    }
  }

  void _textListener() {
    final tagName = _tagTypeNotifier.value.tagName(context);
    _tasksBloc.add(
      TasksEvent.filterTasksOnTagAndName(
        tagName: tagName,
        isShowAll: tagName == context.locale.all,
        search: _searchController.text,
      ),
    );
  }

  void _generateDates() {
    final today = DateTime.now();
    for (int i = 0; i < 20; i++) {
      dates.add(
        today.add(
          Duration(days: i),
        ),
      );
    }
  }

  final List<DateTime> dates = [];

  void _onTapDate() async => showCalendarDatePicker2Dialog(
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
      ).then(
        (value) {
          if (value != null && value.isNotEmpty) {
            _selectedDateNotifier.value = value.first!;
            _tasksBloc.add(TasksEvent.filterTasksOnDate(date: value.first!));
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.h,
          forceMaterialTransparency: true,
          flexibleSpace: _AppBarContent(
            selectedDateNotifier: _selectedDateNotifier,
            tasksBloc: _tasksBloc,
          ),
        ),
        body: ValueListenableBuilder(
            valueListenable: _hasFocusNotifier,
            builder: (context, hasFocus, _) {
              return BlocBuilder<TasksBloc, TasksState>(
                builder: (context, state) {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      _tasksBloc.add(
                          const TasksEvent.getTasks(isShowAllTasks: false));
                    },
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Gap(40.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                          ),
                          child: AppTextField(
                            focusNode: _focusNode,
                            prefixIcon: Icon(
                              Icons.search,
                              size: 24,
                              color: context.colorScheme.onSecondary,
                            ),
                            controller: _searchController,
                            hint: context.locale.whatDone,
                          ),
                        ),
                        Gap(30.h),
                        if (!hasFocus) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 9.h,
                                  ),
                                  child: ValueListenableBuilder(
                                      valueListenable: _selectedDateNotifier,
                                      builder: (context, date, _) {
                                        return Text(
                                          DateFormat('d MMMM', 'ru_RU')
                                              .format(date),
                                          style: TextStyle(
                                            fontFamily: FontFamily.poppins,
                                            fontSize: 25.sp,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                context.colorScheme.onSecondary,
                                          ),
                                        );
                                      }),
                                ),
                                AppIconButton(
                                  icon: SvgPicture.asset(
                                    Assets.icons.calenderIcon,
                                  ),
                                  onTap: _onTapDate,
                                )
                              ],
                            ),
                          ),
                          Gap(8.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                            ),
                            child: state.map(
                              initial: (_) => const SizedBox(),
                              loading: (_) => const SizedBox(),
                              success: (state) => Text(
                                state.activeTasks.isNotEmpty
                                    ? '${state.activeTasks.length} задача на сегодня'
                                    : context.locale.noTask,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  fontFamily: FontFamily.poppins,
                                  color: context.colorScheme.surface,
                                ),
                              ),
                            ),
                          ),
                          Gap(30.h),
                          SizedBox(
                            height: 118.h,
                            child: ListWheelScrollViewX.useDelegate(
                              controller: _scrollController,
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemExtent: 64,
                              squeeze: 0.94,
                              perspective: 0.0001,
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: dates.length,
                                builder: (context, index) =>
                                    ValueListenableBuilder(
                                        valueListenable: _selectedDateNotifier,
                                        builder: (context, date, _) {
                                          return TapAnimation(
                                            onTap: () {
                                              _selectedDateNotifier.value =
                                                  dates[index];
                                              _tasksBloc.add(
                                                TasksEvent.filterTasksOnDate(
                                                    date: dates[index]),
                                              );
                                            },
                                            child: DateHolder(
                                              dateTime: dates[index],
                                              isSelectedDate: (date.day ==
                                                      dates[index].day &&
                                                  date.month ==
                                                      dates[index].month),
                                            ),
                                          );
                                        }),
                              ),
                            ),
                          ),
                        ] else
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                            ),
                            child: ValueListenableBuilder(
                                valueListenable: _tagTypeNotifier,
                                builder: (context, tagType, _) {
                                  return TagsPanel(
                                    currentType: tagType,
                                    onChange: (value) {
                                      _tagTypeNotifier.value = value;
                                      final tagName = value.tagName(context);
                                      _tasksBloc.add(
                                        TasksEvent.filterTasksOnTagAndName(
                                          tagName: tagName,
                                          isShowAll:
                                              tagName == context.locale.all,
                                          search: _searchController.text,
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ),
                        Gap(30.h),
                        ...state.map(
                            initial: (_) => [
                                  const SizedBox(),
                                ],
                            loading: (_) => [
                                  for (int i = 0; i < 5; i++)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.w,
                                        vertical: 5.h,
                                      ),
                                      child: Shimmer.fromColors(
                                          baseColor:
                                              context.colorScheme.onPrimary,
                                          highlightColor:
                                              context.colorScheme.onSurface,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: context
                                                    .colorScheme.onPrimary,
                                              ),
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            width: double.infinity,
                                            height: 68,
                                          )),
                                    ),
                                ],
                            success: (state) => [
                                  for (var task in state.activeTasks)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.w,
                                        vertical: 5.h,
                                      ),
                                      child: TaskHolder(
                                        onChanged: (value) {},
                                        task: task,
                                      ),
                                    ),
                                  Gap(28.h),
                                ]),
                        if (state.mapOrNull(
                                success: (state) =>
                                    state.doneTasks.isNotEmpty) ??
                            false) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.locale.completed,
                                  style: TextStyle(
                                    fontFamily: FontFamily.poppins,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: context.colorScheme.onSecondary,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: context.colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                          Gap(20.h),
                          ...state.map(
                            initial: (_) => [const SizedBox()],
                            loading: (_) => [const SizedBox()],
                            success: (state) => [
                              for (var task in state.doneTasks)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 5.h,
                                  ),
                                  child: TaskHolder(
                                    onChanged: (value) {},
                                    task: task,
                                  ),
                                ),
                            ],
                          ),
                          Gap(28.h),
                        ],
                      ],
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}

class _AppBarContent extends StatelessWidget {
  const _AppBarContent({
    required this.selectedDateNotifier,
    required this.tasksBloc,
  });

  final ValueNotifier<DateTime> selectedDateNotifier;
  final TasksBloc tasksBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBackButton(
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 20,
                color: context.colorScheme.onSecondary,
              ),
              onTap: () => context.read<AuthBloc>().add(
                    const AuthEvent.logout(),
                  ),
            ),
            Text(
              context.locale.myTask,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.poppins,
                color: context.colorScheme.onSecondary,
              ),
            ),
            TapAnimation(
              onTap: () => context
                  .pushRoute(
                const CreateTaskRoute(),
              )
                  .then(
                (_) {
                  selectedDateNotifier.value = DateTime.now();
                  tasksBloc.add(
                        const TasksEvent.getTasks(isShowAllTasks: false),
                      );
                },
              ),
              child: SvgPicture.asset(
                Assets.icons.plusIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
