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
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: CupertinoSearchTextField(
                  controller: textController,
                  placeholder: 'Search',
                ),
              ),
              const SizedBox(
                height: 30,
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
                      return const Center(
                        child: Text("No Data"),
                      );
                    }
                    return state is GetAllDiaryLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: 575,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Column(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 50,
                                    child: Center(
                                      child: Text(_getAllDiaryBloc
                                          .getAllDiaries[index].happened
                                          .validate()),
                                    ),
                                  ),
                                ],
                              ),
                              separatorBuilder: (context, index) =>
                                  const Divider().paddingSymmetric(horizontal: 16),
                              itemCount: _getAllDiaryBloc.getAllDiaries.length,
                              shrinkWrap: true,
                            ),
                          );
                  },
                ).paddingSymmetric(horizontal: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
