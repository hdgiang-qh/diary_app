import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:diary/src/bloc/search_userDiary/diary_user_search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                      height: 80,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://static.antoree.com/avatar.png"))),
                      child: Container()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Name : ${state.ifUser1.nickName.validate()}"),
                      Text("Phone : ${state.ifUser1.phone.validate()}"),
                      Text("Age : ${state.ifUser1.age.validate().toString()}"),
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
    return BlocBuilder<DiaryUserSearchBloc, DiaryUserSearchState>(
        bloc: _diaryUserSearchBloc,
        builder: (context, state) {
          return state is DiaryUserSearchLoading
              ? Center(child: const CircularProgressIndicator().paddingTop(5))
              : (_diaryUserSearchBloc.list.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
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
                            ).paddingOnly(left: 5, bottom: 5, top: 5),
                            SingleChildScrollView(
                              child: SizedBox(
                                child: Text(
                                    _diaryUserSearchBloc.list[index].happened.validate(),
                                    style: const TextStyle(fontSize: 14.0),
                                    maxLines: null),
                              ),
                            ).paddingOnly(left: 5),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    _diaryUserSearchBloc.list[index].createdAt.validate())),
                            const Divider(
                              height: 1,
                              color: Colors.grey,
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
        title: const Text('Trang Cas Nhan'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildInforSearch(),
            const SizedBox(height: 10,),
            buildList()
          ],
        ),
      ),
    );
  }
}
