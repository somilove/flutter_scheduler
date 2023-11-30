import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

//일정정보를 입력할 수 있는 위젯
class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  @override
  Widget build(BuildContext context) {
    //키보드 높이 가져오기
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Container(
        //화면 반 높이에 키보드 높이 추가하기 + bottomInset
        //MediaQuery의 viewInsets.를 가져오면 시스템이 차지하는 화면 아랫부분 크기를 알 수 있음. 일반적으로 이 값은 키보드가 보일 때 차지하는 크기
        //최대 높이에 키보드 크기만큼 높이를 더해주어 키보드가 화면에 보일 때 컨테이너 크기를 늘려준다.
        height: MediaQuery.of(context).size.height / 2 + bottomInset,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Column(
            //시간 관련 텍스트 필드와 내용 관련 텍스트 필드 세로로 배치
            children: [
              const Row(
                //시작 시간 종료 시간 가로로 배치
                children: [
                  Expanded(
                      child: CustomTextField(
                        label: '시작 시간',
                        isTime: true,
                      ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: CustomTextField(
                        label: '종료 시간',
                        isTime: true,
                      ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Expanded(
                  child: CustomTextField(
                    label: '내용',
                    isTime: false,
                  ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  //저장버튼
                  onPressed: onSavePressed,
                  style: ElevatedButton.styleFrom(
                    primary: PRIMARY_COLOR,
                  ),
                  child: const Text('저장'),
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  void onSavePressed() {}
}