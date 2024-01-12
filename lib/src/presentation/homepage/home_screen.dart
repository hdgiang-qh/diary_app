import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:diary/src/bloc/getAlldiary_bloc/get_all_diary_bloc.dart';
import 'package:diary/src/presentation/HomePage/Search/search_screen.dart';
import 'package:diary/src/presentation/HomePage/comment_screen.dart';
import 'package:diary/src/presentation/homepage/separator_widget.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GetAllDiaryBloc _bloc;
  late final InforBloc _inforBloc;
  String? length;

  @override
  void initState() {
    super.initState();
    _bloc = GetAllDiaryBloc();
    _bloc.getAllDiary();
    _inforBloc = InforBloc();
    _inforBloc.getInforUser();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  void refreshPage() {
    _bloc.getAllDiaries.clear();
    _bloc.getAllDiary();
  }

  Widget buildListDiary() {
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<GetAllDiaryBloc, GetAllDiaryState>(
      bloc: _bloc,
      builder: (context, state) {
        return state is GetAllDiaryEmpty
            ? const Center(
                child: Text("Dữ liệu trống"),
              )
            : SmartRefresher(
                controller: _bloc.refreshController,
                onRefresh: () {
                  _bloc.getAllDiaries.clear();
                  _bloc.getAllDiary(isRefresh: true);
                  EasyLoading.dismiss();
                },
                child: ListView.separated(
                  itemBuilder: (context, index) => Container(
                    color: Colors.white70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SeparatorWidget(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(_bloc
                                          .reversedList[index].avatar
                                          .validate()
                                          .toString()),
                                      fit: BoxFit.cover),
                                ),
                                child: Container(),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _bloc.reversedList[index].nickname
                                        .validate(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "đang cảm thấy: ${_bloc.reversedList[index].mood.validate()},  mức độ : ${_bloc.reversedList[index].level.validate()}",
                                    style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          letterSpacing: .5),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ).paddingOnly(top: 5, left: 10, bottom: 10),
                        SingleChildScrollView(
                          child: SizedBox(
                            child: Text(
                                "Sự việc: ${_bloc.reversedList[index].happened.validate()}",
                                style: const TextStyle(fontWeight: FontWeight.w600),
                                maxLines: null),
                          ),
                        ).paddingSymmetric(horizontal: 10),
                        Divider(
                          endIndent: width * 0.6,
                          color: Colors.grey,
                        ).paddingSymmetric(horizontal: 10),
                        Text(
                          'Cảm xúc lúc đó: ${_bloc.reversedList[index].thinkingFelt.validate()}',
                          style: const TextStyle(),
                        ).paddingSymmetric(horizontal: 10),
                        Text(
                          'Sau khi suy nghĩ: ${_bloc.reversedList[index].thinkingMoment.validate()}',
                          style: const TextStyle(),
                        ).paddingSymmetric(horizontal: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              () {
                                if (_bloc.reversedList[index].createdAt !=
                                    null) {
                                  try {
                                    DateTime createdAt = DateTime.parse(_bloc
                                        .reversedList[index].createdAt
                                        .toString());
                                    String formattedTime =
                                        DateFormat('dd-MM-yyyy')
                                            .format(createdAt);
                                    DateTime now = DateTime.now();
                                    Duration dif = createdAt.difference(now);
                                    int days = dif.inDays.abs();
                                    int hour = dif.inHours.abs();
                                    int minute = dif.inMinutes.abs();
                                    String showTime;
                                    days > 3
                                        ? showTime = formattedTime
                                        : 0 < days && days <= 3
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
                              }(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ).paddingOnly(right: 10, bottom: 3, top: 3),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                          thickness: 1,
                          indent: 8,
                          endIndent: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(children: [
                                Text(
                                  'vào ${_bloc.reversedList[index].date.validate().toString()}, ${_bloc.reversedList[index].time.validate().toString()}',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: .5),
                                  ),
                                ),
                                Text(
                                  _bloc.reversedList[index].place.validate(),
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: .5),
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 45,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    // side: const BorderSide(
                                    //     width: 2, color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.comment_bank_outlined,
                                    size: 12,
                                    color: Colors.black,
                                  ),
                                  label: const Text('Bình Luận',
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CommentScreen(
                                                  id: _bloc
                                                      .reversedList[index].id
                                                      .validate(),
                                                  idUser: _inforBloc.ifUser!.id
                                                      .validate(),
                                              idUserDiary: _bloc.reversedList[index].createdBy.validate().toInt(),
                                                )));
                                    refreshPage();
                                  },
                                ).paddingSymmetric(vertical: 5),
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 10),
                      ],
                    ),
                  ),
                  separatorBuilder: (context, index) => Container(),
                  itemCount: _bloc.reversedList.length,
                  shrinkWrap: true,
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorAppStyle.button,
        automaticallyImplyLeading: false,
        title: const Text(
          "Nhật Ký Thường Ngày",
        ),
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
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                color: Colors.white,
                child: CupertinoSearchTextField(
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border.all(width: 1, color: Colors.black54),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  enabled: true,
                  placeholder: 'Search',
                  placeholderStyle: const TextStyle(color: Colors.black54),
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchScreen()));
                    refreshPage();
                  },
                ),
              ),
              Expanded(child: buildListDiary()),
            ],
          ).paddingSymmetric(horizontal: 0),
        ),
      ),
    );
  }
}
