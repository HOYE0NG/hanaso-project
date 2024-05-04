import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hanaso_front/service/api_client.dart';

import '../../../interface/user_interface.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDay = DateTime.now().toUtc().add(Duration(hours: 9));

  //DateTime? _selectedDay;
  String? username;
  ValueNotifier<List<String>> _attendance = ValueNotifier<List<String>>([]);

  ApiClient _apiClient() => ApiClient();

  @override
  void initState() {
    super.initState();
    loadUserName();
    print(_focusedDay);
    loadAttendance();
  }

  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  Future<void> loadAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? attendanceData = prefs.getStringList('attendance');
    print(attendanceData);
    if (attendanceData != null) {
      setState(() {
        _attendance.value = attendanceData;
      });
    }
  }

  //새로 출석체크
  Future<void> saveAttendance() async {
    DateTime nowInKorea = DateTime.now().toUtc().add(Duration(hours: 9));
    if (await _apiClient()
        .saveAttendanceToServer(username!, nowInKorea.toIso8601String())) {
      //print(_focusedDay);
      _attendance.value.add(nowInKorea.toIso8601String().substring(0, 10));
    }
  }

  void checkIn() {
    setState(() {
      saveAttendance(); // Save attendance data to SharedPreferences
    });
  }

  int countAttendanceThisMonth() {
    int count = 0;
    int currentMonth = DateTime.now().toUtc().add(Duration(hours: 9)).month;
    for (String date in _attendance.value) {
      if (DateTime.parse(date).month == currentMonth) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Align text to the left
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 20, bottom: 10),
              child: RichText(
                text: TextSpan(
                  text: '$username',
                  style: TextStyle(color: Colors.orangeAccent, fontSize: 25),
                  children: <TextSpan>[
                    TextSpan(
                        text: '님 안녕하세요!',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 25)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: RichText(
                text: TextSpan(
                  text: '이번 달은 ',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${countAttendanceThisMonth()}',
                      style: TextStyle(color: Colors.orange, fontSize: 20),
                    ),
                    TextSpan(
                      text: '일 출석했어요.',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ValueListenableBuilder(
                  valueListenable: _attendance,
                  builder: (context, value, child) {
                    return TableCalendar(
                      //locale: 'ko_KR',
                      availableCalendarFormats: const {
                        CalendarFormat.month: '월',
                      },
                      focusedDay: _focusedDay,
                      firstDay: DateTime.utc(2018, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 16),

                      calendarBuilders: CalendarBuilders(
                        //focused
                        selectedBuilder: (context, date, events) {
                          return Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                        markerBuilder: (context, date, events) {
                          String currentDate =
                              date.toIso8601String().substring(0, 10);
                          if (_attendance.value.any((item) =>
                                  item.substring(0, 10) == currentDate) &&
                              (currentDate !=
                                  DateTime.now()
                                      .toUtc()
                                      .add(Duration(hours: 9))
                                      .toIso8601String()
                                      .substring(0, 10))) {
                            return Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.3), // 주황색 배경
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.brown),
                              ),
                            );
                          } else if (date.isAfter(
                              DateTime.now().toUtc().add(Duration(hours: 9)))) {
                            return null;
                          } else {
                            return null;
                          }
                        },
                      ),
                    );
                  }),
            ),
            SizedBox(height: 20.0),
            if (!_attendance.value.any((item) =>
                item.substring(0, 10) ==
                DateTime.now()
                    .toUtc()
                    .add(Duration(hours: 9))
                    .toIso8601String()
                    .substring(0, 10)))
              Center(
                child: ElevatedButton(
                  onPressed: checkIn,
                  child: Text('출석체크하기'),
                ),
              )
            else
              Center(
                child: Text('출석체크 완료'),
              ),
            SizedBox(height: 20.0),
            CustomOutlinedButton(
              onPressed: () {
                // Navigate to Settings Page
              },
              child: Row(
                children: [
                  Icon(Icons.swap_horiz),
                  SizedBox(width: 8.0), // Add some spacing
                  Text('출석 아이템 교환'),
                ],
              ),
            ),
            CustomOutlinedButton(
              onPressed: () {
                // Navigate to Settings Page
              },
              child: Row(
                children: [
                  Icon(Icons.history),
                  SizedBox(width: 8.0), // Add some spacing
                  Text('최근 학습 기록'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
