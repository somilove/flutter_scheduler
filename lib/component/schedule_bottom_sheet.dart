import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:get_it/get_it.dart';
import 'package:calendar_scheduler/database/drift_database.dart';

import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:provider/provider.dart';

//일정정보를 입력할 수 있는 위젯
class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleBottomSheet({
    required this.selectedDate,
    Key? key
  }) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey(); //폼 key 생성

  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    //키보드 높이 가져오기
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    //MediaQuery의 viewInsets.를 가져오면 시스템이 차지하는 화면 아랫부분 크기를 알 수 있음. 일반적으로 이 값은 키보드가 보일 때 차지하는 크기

    return Form( //텍스트 필드를 한 번에 관리할 수 있는 폼
      key: formKey, //Form을 조작할 키값
       //Form 위젯의 key 매개변수에 GlobalKey값을 넣어주어 폼을 조작할 때 같은 key값을 이용해
       //Form 내부의 TextFormField들을 일괄 조직
      child: SafeArea(
        child: Container(
          //키보드 크기만큼 높이를 더해주어 키보드가 화면에 보일 때 컨테이너 크기를 늘려준다. + bottomInset
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Column(
              //시간 관련 텍스트 필드와 내용 관련 텍스트 필드 세로로 배치
              children: [
                 Row(
                  //시작 시간 종료 시간 가로로 배치
                  children: [
                    Expanded(
                        child: CustomTextField(
                          label: '시작 시간',
                          isTime: true,
                          onSaved: (String? val) {
                            //저장이 실행되면 startTime 변수에 텍스트 필드값 저장
                            startTime = int.parse(val!);
                          },
                          validator: timeValidator,
                        ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                        child: CustomTextField(
                          label: '종료 시간',
                          isTime: true,
                          onSaved: (String? val) {
                            //저장이 실행되면 endTime 변수에 텍스트 필드값 저장
                            endTime = int.parse(val!);
                          },
                          validator: timeValidator,
                        ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Expanded(
                    child: CustomTextField(
                      label: '내용',
                      isTime: false,
                      onSaved: (String? val) {
                        //저장이 실행되면 content 변수에 텍스트 필드값 저장
                        content = val;
                      },
                      validator: contentValidator,
                    ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton( //저장버튼
                    onPressed: () => onSavePressed(context),
                    style: ElevatedButton.styleFrom(
                      primary: PRIMARY_COLOR,
                    ),
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  void onSavePressed(BuildContext context) async {
    if(formKey.currentState!.validate()) { //폼 검증하기
      formKey.currentState!.save(); //폼 저장하기

    // await GetIt.I<LocalDatabase>().createSchedule(
    //   SchedulesCompanion(  //createSchedule은 SchedulesCompanion를 매개변수로 받음
    //     startTime: Value(startTime!),
    //     endTime: Value(endTime!),
    //     content: Value(content!),
    //     date: Value(widget.selectedDate),
    //   ),
    // );

      context.read<ScheduleProvider>().createSchedule(
        schedule:ScheduleModel(
          id: 'new_model',
          content: content!,
          date: widget.selectedDate,
          startTime: startTime!,
          endTime: endTime!,
        )
      );
    Navigator.of(context).pop();
    }
  }

  String? timeValidator(String? val) { //시간 검증 함수
    if (val == null) {
      return '값을 입력해주세요';
    }

    int? number;

    try {
      number = int.parse(val);
    } catch (e) {
      return '숫자를 입력해주세요';
    }

    if( number < 0 || number > 24) {
      return '0시부터 24시 사이를 입력해주세요';
    }

    return null;
  }

  String? contentValidator(String? val) { //내용 검증 함수
    if( val == null || val.length == 0 ) {
      return '값을 입력해주세요';
    }

    return null;
  }
}