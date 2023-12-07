import 'package:diary/src/bloc/num_bloc.dart';
import 'package:diary/src/presentation/Diary/add_diary_screen.dart';
import 'package:diary/src/presentation/Diary/edit_diary_screen.dart';
import 'package:diary/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
  String choosesDate = 'Choose Day';
  String? note;

  @override
  void initState() {
    super.initState();
    _bloc = DiaryUserBloc();
    _bloc.getListDU();
  }

  void toastDeleteComplete(String messenger) => Fluttertoast.showToast(
      msg: "Delete Success",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  Widget buildDate() {
    return ElevatedButton(
      onPressed: () async {
        DateTime? picker = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2018),
            lastDate: DateTime(2025));
        setState(() {
          _bloc.time = picker;
          _bloc.listDU.clear();
          _bloc.getListDU();
        });
      },
      child: const Text("Choose Day"),
    );
  }

  Widget buildDateV2() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 20),
      lastDay: DateTime.utc(2040, 10, 20),
      focusedDay: DateTime.now(),
      headerVisible: true,
      daysOfWeekVisible: true,
      sixWeekMonthsEnforced: true,
      shouldFillViewport: false,
      headerStyle: const HeaderStyle(
        titleTextStyle: TextStyle(color: Colors.red, fontSize: 20.0),
        decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        formatButtonTextStyle: TextStyle(color: Colors.orange, fontSize: 16.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.blue,
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
          todayTextStyle: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget buildListDiary() {
    return Container(
      child: BlocBuilder<DiaryUserBloc, DiaryuserState>(
        bloc: _bloc,
        builder: (context, state) {
          return state is DiaryUserLoading
              ? Center(child: const CircularProgressIndicator().paddingTop(5))
              : (_bloc.listDU.isEmpty
                  ? const Center(
                      child: Text("Not Value"),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    _bloc.listDU[index].nickname
                                        .validate()
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  _bloc.listDU[index].status.toString(),
                                  style: TextStyle(
                                      color: _bloc.listDU[index].status
                                                  .toString() ==
                                              "PUBLIC"
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold),
                                )),
                              ],
                            ).paddingOnly(left: 5, bottom: 5, top: 5),
                            SingleChildScrollView(
                              child: SizedBox(
                                child: Text(
                                    _bloc.listDU[index].happened.validate(),
                                    style: const TextStyle(fontSize: 14.0),
                                    maxLines: null),
                              ),
                            ).paddingOnly(left: 5),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(() {
                                  if (_bloc.listDU[index].createdAt != null) {
                                    try {
                                      DateTime createdAt = DateTime.parse(_bloc
                                          .listDU[index].createdAt
                                          .toString());

                                      String formattedTime =
                                          DateFormat('dd-MM-yyyy')
                                              .format(createdAt);
                                      return formattedTime;
                                    } catch (e) {
                                      return '';
                                    }
                                  } else {
                                    return '';
                                  }
                                }())),
                            const Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditDiaryScreen(
                                                      id: _bloc.listDU[index].id
                                                          .validate(),
                                                    )));
                                      },
                                      child: const Text(
                                        "Edit Diary",
                                        style: TextStyle(fontSize: 12),
                                      )),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
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
                                                    'Do you want to remove this diary from the list?',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      isDefaultAction: true,
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
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
                                                        Navigator.pop(context);
                                                        toastDeleteComplete("");
                                                        _bloc.getListDU();
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
                                      child: const Icon(
                                        Icons.delete_forever,
                                        size: 14,
                                      )),
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
      ).paddingSymmetric(horizontal: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Your Diary"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddDiaryScreen()));
                },
                icon: const Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  _bloc.listDU.clear();
                  _bloc.getListDU();
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[buildDate(), buildDateV2(), buildListDiary()],
            ),
          ).paddingSymmetric(horizontal: 5),
        ));
  }
}
