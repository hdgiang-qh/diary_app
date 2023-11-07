import 'package:diary/src/bloc/getAlldiary_bloc/get_all_diary_bloc.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/service/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GetAllDiaryBloc _getAllDiaryBloc;
  late TextEditingController textController;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _getAllDiaryBloc = GetAllDiaryBloc();
    _getAllDiaryBloc.getAllDiary();
    textController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Diary For You",
        ),
        actions: [
          GestureDetector(
            child: const CircleAvatar(
              backgroundColor: primaryColor,
              child: Text('G'),
            ).paddingRight(10),
            onTap: () {
              if (kDebugMode) {
                print('hello');
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 10, right: 10),
                child: CupertinoSearchTextField(
                  controller: textController,
                  placeholder: 'Search',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // SizedBox(
              //   width: 200,
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       await authService.logout();
              //       Provider.of<AuthProvider>(context, listen: false).setToken(null);
              //       Navigator.pop(context);
              //     },
              //     child: const Text('Đăng xuất'),
              //   ),
              // ),
              Container(
                child: BlocBuilder<GetAllDiaryBloc, GetAllDiaryState>(
                  bloc: _getAllDiaryBloc,
                  builder: (context, state) {
                    if (_getAllDiaryBloc.getAllDiaries.isEmpty) {
                      return const CircularProgressIndicator();
                      // Center(
                      //   child: Text("No Data"),
                      // );
                    }
                    return state is GetAllDiaryLoading
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
                                                const CircleAvatar(
                                                  radius: 20.0,
                                                  child: Text("G"),
                                                ).paddingRight(5),
                                                Text(
                                                  _getAllDiaryBloc
                                                      .getAllDiaries[index].id
                                                      .validate()
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              " Feeling : ${_getAllDiaryBloc.getAllDiaries[index].thinkingNow.validate()}",
                                            ),
                                          )
                                        ],
                                      ).paddingAll(5),
                                      SingleChildScrollView(
                                        child: SizedBox(
                                          child: Text(
                                              _getAllDiaryBloc
                                                  .getAllDiaries[index].happened
                                                  .validate(),
                                              style: const TextStyle(
                                                  fontSize: 15.0)),
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
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Like',
                                          style: TextStyle(fontSize: 14.0)),
                                      Text(
                                        "|",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text('Comment',
                                          style: TextStyle(fontSize: 14.0)),
                                    ],
                                  ),
                                )
                              ],
                            ).paddingBottom(20),
                            separatorBuilder: (context, index) => Container(),
                            itemCount: _getAllDiaryBloc.getAllDiaries.length,
                            shrinkWrap: true,
                          );
                  },
                ).paddingSymmetric(horizontal: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
