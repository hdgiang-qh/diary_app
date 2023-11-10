import 'package:diary/src/presentation/Diary/add_diary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../bloc/diaryUser_bloc/diaryuser_bloc.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late final DiaryUserBloc _bloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = DiaryUserBloc();
    _bloc.getListDU();
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
                icon: const Icon(Icons.add))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: BlocBuilder<DiaryUserBloc, DiaryuserState>(
                    bloc: _bloc,
                    builder: (context, state) {
                      if (_bloc.listDU.isEmpty) {
                        return const
                        //  CircularProgressIndicator();
                        Center(
                          child: Text("Loading Data..."),
                        );
                      }
                      return state is DiaryUserLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              width: double.infinity,
                              height: 300,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex:2,
                                        child: Row(
                                          children: [
                                            Text(
                                              _bloc
                                                  .listDU[index].nickname
                                                  .validate()
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ).paddingAll(5),
                                  SingleChildScrollView(
                                    child: SizedBox(
                                      child: Text(
                                          _bloc
                                              .listDU[index].happened
                                              .validate(),
                                          style: const TextStyle(
                                              fontSize: 15.0),
                                          maxLines: null),
                                    ),
                                  ).paddingLeft(5),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                // crossAxisAlignment:
                                //     CrossAxisAlignment.center,
                                children: [
                                  Text('Comment',
                                      style: TextStyle(fontSize: 14.0)),
                                ],
                              ),
                            )
                          ],
                        ).paddingBottom(20),
                        separatorBuilder: (context, index) => Container(),
                        itemCount: _bloc.listDU.length,
                        shrinkWrap: true,
                      );
                    },
                  ).paddingSymmetric(horizontal: 10),
                )
              ],
            ),
          ).paddingSymmetric(horizontal: 5),
        ));
  }
}
