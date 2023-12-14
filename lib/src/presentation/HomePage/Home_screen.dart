import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:diary/src/bloc/getAlldiary_bloc/get_all_diary_bloc.dart';
import 'package:diary/src/presentation/HomePage/Search/Search_screen.dart';
import 'package:diary/src/presentation/HomePage/comment_screen.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

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

  void refreshPage() {
    _bloc.getAllDiaries.clear();
    _bloc.getAllDiary();
  }

  Widget buildListDiary() {
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<GetAllDiaryBloc, GetAllDiaryState>(
      bloc: _bloc,
      builder: (context, state) {
        return state is GetAllDiaryLoading
            ? const Center(child: CircularProgressIndicator())
            : (_bloc.getAllDiaries.isEmpty
                ? const Center(
                    child: Text("Dữ liệu trống"),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 5),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 40,
                                  width: 40,
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
                                flex: 9,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _bloc.reversedList[index].nickname
                                          .validate(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "đang cảm thấy : ${_bloc.reversedList[index].mood.validate()},  mức độ : ${_bloc.reversedList[index].level.validate()}",
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: .5),
                                      ),
                                    ),
                                    Text(
                                      'vào ${_bloc.reversedList[index].date.validate().toString()}, ${_bloc.reversedList[index].time.validate().toString()}',
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: .5),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ).paddingOnly(top: 5, left: 10, bottom: 10),
                          SingleChildScrollView(
                            child: SizedBox(
                              child: Text(
                                  "Sự việc : ${_bloc.reversedList[index].happened.validate()}",
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white),
                                  maxLines: null),
                            ),
                          ).paddingSymmetric(horizontal: 10),
                          Divider(
                            endIndent: width * 0.6,
                            color: Colors.white,
                          ).paddingSymmetric(horizontal: 10),
                          Text(
                            'Sau khi suy nghĩ : ${_bloc.reversedList[index].thinkingMoment.validate()}',
                            style: TextStyle(color: Colors.white),
                          ).paddingSymmetric(horizontal: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'tại ${_bloc.reversedList[index].place.validate()}',
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
                              Text(
                                () {
                                  if (_bloc.reversedList[index].createdAt !=
                                      null) {
                                    try {
                                      DateTime createdAt = DateTime.parse(_bloc
                                          .reversedList[index].createdAt
                                          .toString());
                                      // String formattedTime =
                                      //     DateFormat('dd-MM-yyyy').format(createdAt);
                                      DateTime now = DateTime.now();
                                      Duration dif = createdAt.difference(now);
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
                                }(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ).paddingOnly(right: 10, bottom: 3, top: 3),
                          const Divider(
                            height: 1,
                            color: Colors.white,
                            thickness: 1,
                            indent: 8,
                            endIndent: 8,
                          ),
                          Center(
                            child: SizedBox(
                              height: 30,
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
                                  Icons.comment_bank_outlined,
                                  size: 16,
                                ),
                                label: const Text('Bình Luận',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CommentScreen(
                                                id: _bloc.reversedList[index].id
                                                    .validate(),
                                                idUser: _inforBloc.ifUser!.id
                                                    .validate(),
                                              )));
                                  refreshPage();
                                },
                              ),
                            ).paddingSymmetric(vertical: 5),
                          ),
                        ],
                      ),
                    ).paddingBottom(5),
                    separatorBuilder: (context, index) => Container(),
                    itemCount: _bloc.reversedList.length,
                    shrinkWrap: true,
                  ));
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
        actions: [
          GestureDetector(
            child: const CircleAvatar(
              child: Text("A"),
            ).paddingRight(10),
            onTap: () {
              if (kDebugMode) {
                print('hello');
              }
            },
          )
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
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 5, right: 5, bottom: 10),
                  child: CupertinoSearchTextField(
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        border: Border.all(width: 0.5, color: Colors.white),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    enabled: true,
                    placeholder: 'Search',
                    placeholderStyle: const TextStyle(color: Colors.black),
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchScreen()));
                      refreshPage();
                    },
                  ),
                ),
                buildListDiary(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
