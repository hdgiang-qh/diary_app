import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:diary/src/bloc/search_userDiary/diary_user_search_bloc.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewSearchScreen extends StatefulWidget {
  final int? createBy;

  const ViewSearchScreen({super.key, required this.createBy});

  @override
  State<ViewSearchScreen> createState() => _ViewSearchScreenState();
}

class _ViewSearchScreenState extends State<ViewSearchScreen> {
  late final InforBloc _inforBloc;
  late final DiaryUserSearchBloc _diaryUserSearchBloc;

  @override
  void initState() {
    super.initState();
    _diaryUserSearchBloc = DiaryUserSearchBloc();
    _diaryUserSearchBloc.getListSearch(id: widget.createBy);
    _inforBloc = InforBloc();
    _inforBloc.getSearchId(id: widget.createBy);
  }

  Widget buildInforSearch() {
    return BlocBuilder<InforBloc, InforState>(
        bloc: _inforBloc,
        builder: (context, state) {
          if (state is InforLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is InforSuccess3) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  state.ifUser1.avatar.validate()))),
                      child: Container()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          "Tên người dùng : ${state.ifUser1.nickName.validate()}"),
                      Text("Số điện thoại : ${state.ifUser1.phone.validate()}"),
                      Text("Tuổi : ${state.ifUser1.age.validate().toString()}"),
                      Text("Email : ${state.ifUser1.email.validate()}")
                    ],
                  )
                ],
              ).paddingTop(15),
            );
          } else if (state is InforFailure) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return Container();
          }
        });
  }

  Widget buildList() {
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<DiaryUserSearchBloc, DiaryUserSearchState>(
        bloc: _diaryUserSearchBloc,
        builder: (context, state) {
          return state is DiaryUserSearchLoading
              ? const Center(child: Text('Data Loading...'))
              : (_diaryUserSearchBloc.list.isEmpty
                  ? const Center(
                      child: Text('Not Value'),
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
                              BorderRadius.circular(20), //<-- SEE HERE
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      _diaryUserSearchBloc.list[index].nickname
                                          .validate()
                                          .toString(),
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
                                            topRight: Radius.circular(20))),
                                    child: Text(
                                      _diaryUserSearchBloc.list[index].status
                                          .toString(),
                                      style: TextStyle(
                                          color: _diaryUserSearchBloc
                                                      .list[index].status
                                                      .toString() ==
                                                  "PUBLIC"
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                ],
                              ).paddingOnly(left: 10, right: 3),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "đang cảm thấy : ${_diaryUserSearchBloc.list[index].mood.validate()},  mức độ : ${_diaryUserSearchBloc.list[index].level.validate()}",
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: .5),
                                  ),
                                ),
                                Text(
                                  'vào ${_diaryUserSearchBloc.list[index].date.validate().toString()}, ${_diaryUserSearchBloc.list[index].time.validate().toString()}',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: .5),
                                  ),
                                )
                              ],
                            ).paddingSymmetric(horizontal: 10),
                            SingleChildScrollView(
                              child: SizedBox(
                                child: Text(
                                    "Sự việc: ${_diaryUserSearchBloc.list[index].happened.validate()}",
                                    style: const TextStyle(
                                        fontSize: 14.0, color: Colors.white),
                                    maxLines: null),
                              ),
                            ).paddingSymmetric(horizontal: 10, vertical: 5),
                            Divider(
                              endIndent: width * 0.6,
                              color: Colors.white,
                            ).paddingSymmetric(horizontal: 10),
                            Text(
                              'Sau khi suy nghĩ : ${_diaryUserSearchBloc.list[index].thinkingMoment.validate()}',
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                            ).paddingSymmetric(horizontal: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'tại ${_diaryUserSearchBloc.list[index].place.validate()}',
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
                                    if (_diaryUserSearchBloc
                                            .list[index].createdAt !=
                                        null) {
                                      try {
                                        DateTime createdAt = DateTime.parse(
                                            _diaryUserSearchBloc
                                                .list[index].createdAt
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
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ).paddingBottom(5),
                      separatorBuilder: (context, index) => Container(),
                      itemCount: _diaryUserSearchBloc.list.length,
                      shrinkWrap: true,
                    ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorAppStyle.app5,
        title: const Text('Trang Cá Nhân'),
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
                buildInforSearch(),
                const SizedBox(
                  height: 10,
                ),
                buildList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
