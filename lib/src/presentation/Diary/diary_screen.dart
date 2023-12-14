import 'package:diary/src/bloc/num_bloc.dart';
import 'package:diary/src/presentation/Diary/add_diary_screen.dart';
import 'package:diary/src/presentation/Diary/edit_diary_screen.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:diary/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../bloc/diaryUser_bloc/diaryuser_bloc.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final NumBloc numBloc = NumBloc();
  late final date = DateTime.now();
  late final formatter = DateFormat('yyyy-MM-dd');
  late String startDate = formatter.format(date);
  late final DiaryUserBloc _bloc;
  CalendarFormat format = CalendarFormat.month;
  String choosesDate = 'Chọn Ngày';
  String? note;
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _bloc = DiaryUserBloc();
    _bloc.getListDU();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
  }

  void toastDeleteComplete(String messenger) => Fluttertoast.showToast(
      msg: "Delete Success",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  void ToastDeleteSuccess() {
    MotionToast(
      icon: Icons.check_circle,
      primaryColor: Colors.blue[600]!,
      secondaryColor: Colors.lightBlueAccent,
      backgroundType: BackgroundType.solid,
      title: const Text(
        'Xoá thành công',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Container(),
      position: MotionToastPosition.top,
      // layoutOrientation: ToastOrientation.rtl,
      animationDuration: const Duration(seconds: 1),
      width: 300,
      height: 50,
    ).show(context);
  }


  Widget buildDate() {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: _firstDay,
      lastDay: _lastDay,
      calendarFormat: format,
      onFormatChanged: (CalendarFormat _format) {
        setState(() {
          format = _format;
        });
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          _bloc.listDU.clear();
          _bloc.time = selectedDay;
          _bloc.getListDU();
        });
      },
      headerVisible: true,
      daysOfWeekVisible: true,
      sixWeekMonthsEnforced: true,
      shouldFillViewport: false,
      headerStyle: const HeaderStyle(
        titleTextStyle: TextStyle(color: Colors.red, fontSize: 20.0),
        decoration: BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        formatButtonTextStyle: TextStyle(color: Colors.orange, fontSize: 16.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.grey,
          size: 28,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.green,
          size: 28,
        ),
      ),
      calendarStyle: const CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Colors.blue,
          ),
          todayTextStyle: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget buildListDiary() {
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: BlocBuilder<DiaryUserBloc, DiaryuserState>(
        bloc: _bloc,
        builder: (context, state) {
          return state is DiaryUserLoading
              ? Center(child: const CircularProgressIndicator().paddingTop(5))
              : (_bloc.listDU.isEmpty
                  ? const Center(
                      child: Text("Không có nhật ký nào"),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Card(
                        color: ColorAppStyle.app5,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 2,
                            color: Colors.greenAccent,
                          ),
                          borderRadius:
                              BorderRadius.circular(20.0), //<-- SEE HERE
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "  ${_bloc.listDU[index].nickname.validate().toString()}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15))),
                                      child: Text(
                                        _bloc.listDU[index].status.toString(),
                                        style: TextStyle(
                                            color: _bloc.listDU[index].status
                                                        .toString() ==
                                                    "PUBLIC"
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                  ],
                                ).paddingOnly(left: 5, bottom: 5, top: 5),
                                Column(
                                  children: [
                                    Text(
                                      "đang cảm thấy : ${_bloc.listDU[index].mood.validate()},  mức độ : ${_bloc.listDU[index].level.validate()}",
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: .5),
                                      ),
                                    ),
                                    Text(
                                      'vào ${_bloc.listDU[index].date.validate().toString()}, ${_bloc.listDU[index].time.validate().toString()}',
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: .5),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              child: SizedBox(
                                child: Text(
                                    "Sự việc: ${_bloc.listDU[index].happened.validate()}",
                                    style: const TextStyle(fontSize: 14.0),
                                    maxLines: null),
                              ),
                            ).paddingSymmetric(horizontal: 10),
                            Divider(endIndent: width * 0.6)
                                .paddingSymmetric(horizontal: 10),
                            Text('Sau khi suy nghĩ : ${_bloc.listDU[index].thinkingMoment.validate()}')
                                .paddingSymmetric(horizontal: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'tại ${_bloc.listDU[index].place.validate()}',
                                    style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          letterSpacing: .5),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(() {
                                    if (_bloc.listDU[index].createdAt != null) {
                                      try {
                                        DateTime createdAt = DateTime.parse(
                                            _bloc.listDU[index].createdAt
                                                .toString());
                                        DateTime now = DateTime.now();
                                        Duration dif =
                                            createdAt.difference(now);
                                        int days = dif.inDays.abs();
                                        int hour = dif.inHours.abs();
                                        int minute = dif.inMinutes.abs();
                                        String showTime;
                                        days > 0
                                            ? showTime = "$days ngày trước"
                                            : (hour > 0
                                                ? showTime =
                                                    "${hour % 24} giờ trước"
                                                : showTime =
                                                    "$minute phút trước");
                                        return showTime;
                                      } catch (e) {
                                        return '';
                                      }
                                    } else {
                                      return '';
                                    }
                                  }())
                                ]).paddingSymmetric(horizontal: 10),
                            const Divider(
                              height: 1,
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: 120,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorAppStyle.app8,
                                      side: const BorderSide(
                                          width: 2, color: Colors.white),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 14,
                                    ),
                                    label: const Text('Chỉnh sửa',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditDiaryScreen(
                                                    id: _bloc.listDU[index].id
                                                        .validate(),
                                                  )));
                                      refreshPage();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 120,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorAppStyle.app8,
                                      side: const BorderSide(
                                          width: 2, color: Colors.white),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      size: 14,
                                    ),
                                    label: const Text('Xoá',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        showCupertinoDialog(
                                            context: context,
                                            builder: (context) {
                                              return CupertinoAlertDialog(
                                                title: const Icon(
                                                  CupertinoIcons.info_circle,
                                                ),
                                                content: const Text(
                                                  'Bạn có muốn xoá nhật ký này?',
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    isDefaultAction: true,
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("Cancel",
                                                        style: StyleApp
                                                            .textStyle401()),
                                                  ),
                                                  CupertinoDialogAction(
                                                    isDefaultAction: true,
                                                    onPressed: () {
                                                      _bloc.deletedDiary(_bloc
                                                          .listDU[index].id
                                                          .validate());
                                                      Navigator.of(context)
                                                          .pop();
                                                      ToastDeleteSuccess();
                                                    },
                                                    child: Text("Apply",
                                                        style: StyleApp
                                                            .textStyle402()),
                                                  ),
                                                ],
                                              );
                                            });
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ).paddingSymmetric(vertical: 8)
                          ],
                        ),
                      ).paddingBottom(5),
                      separatorBuilder: (context, index) => Container(),
                      itemCount: _bloc.listDU.length,
                      shrinkWrap: true,
                    ));
        },
      ).paddingSymmetric(horizontal: 5),
    );
  }

  void refreshPage() {
    _bloc.list.clear();
    _bloc.getListDU();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorAppStyle.button,
          automaticallyImplyLeading: false,
          title: const Text("Nhật ký của bạn"),
          actions: [
            IconButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddDiaryScreen()));
                  refreshPage();
                },
                icon: const Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  _bloc.time = null;
                  _bloc.list.clear();
                  _bloc.getListDU();
                },
                icon: const Icon(Icons.refresh)),
          ],
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorAppStyle.app5,
                  ColorAppStyle.app6,
                  ColorAppStyle.app2
                ],
              ),
              image: DecorationImage(
                  image: AssetImage("assets/images/shape.png"),
                  fit: BoxFit.cover)),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  buildDate(),
                  buildListDiary()
                ],
              ),
            ).paddingSymmetric(horizontal: 5),
          ),
        ));
  }
}
