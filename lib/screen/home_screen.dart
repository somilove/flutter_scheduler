import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:get_it/get_it.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:provider/provider.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';


class HomeScreen extends StatelessWidget {
  DateTime selectedDate = DateTime.utc( //선택된 날짜를 관리할 변수
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //프로바이더 변경 있을 때마다 build()함수 재실행
    final provider = context.watch<ScheduleProvider>();
    final selectedDate = provider.selectedDate;
    //선택된 날짜에 해당되는 일정들 가져오기
    final schedules  = provider.cache[selectedDate] ??[];

    return Scaffold(
      floatingActionButton: FloatingActionButton( //새 일정 버튼
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet( //BottomSheet 열기
              context: context,
              isDismissible: true, //배경 탭했을 때 BottomSheet 닫기
              builder: (_) => ScheduleBottomSheet(
                selectedDate: selectedDate, //선택된 날짜 (selectedDate) 넘겨주기
              ),
              isScrollControlled: true,
            //showModalBottomSheet()함수는 기본적으로 최대 높이를 화면의 반으로 규정하지만 isScrollControlled:true로 설정하면 최대 높이를 화면 전체로 변경 가능
            //ScheduleBottomSheet에서 텍스트필드를 선택할 경우 키보드가 보이는 만큼 ScheduleBottomSheet 위젯이 위로 이동됨
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
                selectedDate: selectedDate,
                onDaySelected: (selectedDate, focusedDate) =>
                  onDaySelected(selectedDate, focusedDate, context),
            ),
            const SizedBox(height: 8.0),
            // StreamBuilder<List<Schedule>>( //일정 Stream으로 받아오기
            //   stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
            //   builder: (context, snapshot) {
            //     return TodayBanner(
            //       selectedDate: selectedDate,
            //       count: snapshot.data?.length ?? 0,
            //     );
            //   },
            // ),
            TodayBanner(
                selectedDate: selectedDate,
                count: schedules.length,
            ),
            const SizedBox(height: 8.0),
            // Expanded( //남는 공간을 모두 차지하기
            //   //StreamBuilder를 사용해 일정 관련 데이터가 변경될 때마다 위젯들을 새로 렌디렁
            //   child: StreamBuilder<List<Schedule>>(
            //     stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
            //     builder: (context, snapshot) {
            //       if(!snapshot.hasData){
            //         return Container();
            //       }
            //       return ListView.builder(
            //         itemCount: snapshot.data!.length,
            //         itemBuilder: (context, index) {
            //           //현재 index에 해당되는 일정
            //           final schedule = snapshot.data![index];
            //           return Dismissible(
            //             //유니크한 키값 삭제 제스처가 어디에 적용됐는지 구분할 수 있는 요소로 사용
            //             key: ObjectKey(schedule.id),
            //             //밀기방향 (오른쪽에서 왼쪽으로)
            //             direction: DismissDirection.startToEnd,
            //             //밀기 했을 때 실행할 함수
            //             onDismissed: (DismissDirection direction) {
            //               GetIt.I<LocalDatabase>()
            //                   .removeSchedule(schedule.id);
            //             },
            //             child: Padding(
            //               padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            //               child: ScheduleCard(
            //                 startTime: schedule.startTime,
            //                 endTime: schedule.endTime,
            //                 content: schedule.content,
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                  itemBuilder: (context, index) {
                  final schedule = schedules[index];

                  return Dismissible(
                    key: ObjectKey(schedule.id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (DismissDirection direction) {
                      provider.deleteSchedule(date: selectedDate, id: schedule.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0, left: 8.0, right: 8.0),
                        child: ScheduleCard(
                          startTime: schedule.startTime,
                          endTime: schedule.endTime,
                          content: schedule.content,
                        ),
                    ),
                  );
                  },
              ),
            )
          ],
        ),
      ),
    );
  }

  void onDaySelected(
      DateTime selectedDate,
      DateTime focusedDate,
      BuildContext context) {
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(
      date: selectedDate,
    );
    provider.getSchedules(date: selectedDate);
  }
}