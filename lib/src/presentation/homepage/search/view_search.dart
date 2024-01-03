import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:diary/src/bloc/search_userDiary/diary_user_search_bloc.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../HomePage/comment_screen.dart';

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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    state.ifUser1.avatar.validate()))),
                        child: Container()),
                  ),
                  Flexible(
                    flex:3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            "Tên người dùng : ${state.ifUser1.nickName.validate()}"),
                        Text("Số điện thoại : ${state.ifUser1.phone.validate()}"),
                        Text("Tuổi : ${state.ifUser1.age.validate().toString()}"),
                        Text("Email : ${state.ifUser1.email.validate()}")
                      ],
                    ),
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
  void refreshPage() {
    _diaryUserSearchBloc.list.clear();
    EasyLoading.show(dismissOnTap: true);
    Future.delayed(const Duration(milliseconds: 1000),(){
      _diaryUserSearchBloc.getListSearch(id: widget.createBy);
    }).then((value) => EasyLoading.dismiss());
  }

  Widget buildList() {
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<DiaryUserSearchBloc, DiaryUserSearchState>(
        bloc: _diaryUserSearchBloc,
        builder: (context, state) {
          return state is DiaryUserSearchLoading
              ? const Center(child: Text('Không có nhật ký nào'))
              : (_diaryUserSearchBloc.list.isEmpty
                  ? const Center(
                      child: Text('Danh sách trống'),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 5),
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
                                      )),
                                ],
                              ).paddingOnly(left: 10, right: 3),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "đang cảm thấy: ${_diaryUserSearchBloc.list[index].mood.validate()},  mức độ : ${_diaryUserSearchBloc.list[index].level.validate()}",
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: .5),
                                  ),
                                ),

                              ],
                            ).paddingSymmetric(horizontal: 10),
                            SingleChildScrollView(
                              child: SizedBox(
                                child: Text(
                                    "Sự việc: ${_diaryUserSearchBloc.list[index].happened.validate()}",
                                    style: const TextStyle(
                                       ),
                                    maxLines: null),
                              ),
                            ).paddingSymmetric(horizontal: 10, vertical: 5),
                            Divider(
                              endIndent: width * 0.6,
                              color: Colors.grey,
                            ).paddingSymmetric(horizontal: 10),
                            Text(
                              'Sau khi suy nghĩ: ${_diaryUserSearchBloc.list[index].thinkingMoment.validate()}',
                              style: const TextStyle(
                                ),
                            ).paddingSymmetric(horizontal: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
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
                                  }()),
                                ]).paddingSymmetric(horizontal: 10),
                            const SizedBox(
                              height: 10,
                            ),
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
                                      'vào ${_diaryUserSearchBloc.list[index].date.validate().toString()}, ${_diaryUserSearchBloc.list[index].time.validate().toString()}',
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: .5),
                                      ),
                                    ),
                                    Text(
                                      _diaryUserSearchBloc.list[index].place.validate(),
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: .5),
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(width: 10,),
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
                                                  id: _diaryUserSearchBloc.list[index].id
                                                      .validate(),
                                                  idUser: _inforBloc.ifUserv2!.id
                                                      .validate(),
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
