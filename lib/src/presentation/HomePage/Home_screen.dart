import 'package:diary/src/bloc/getAlldiary_bloc/get_all_diary_bloc.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GetAllDiaryBloc _getAllDiaryBloc;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    _getAllDiaryBloc = GetAllDiaryBloc();
    _getAllDiaryBloc.getAllDiary();
    textController = TextEditingController(text: '');
  }

  Widget buildListDiary() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 5),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 20.0,
                            child: Text("G"),
                          ).paddingRight(5),
                          Text(
                            _getAllDiaryBloc.getAllDiaries[index].nickname
                                .validate()
                                .toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        " Feeling : ${_getAllDiaryBloc.getAllDiaries[index].mood.validate()}",
                      ),
                    )
                  ],
                ).paddingTop(5),
                SingleChildScrollView(
                  child: SizedBox(
                    child: Text(
                        _getAllDiaryBloc.getAllDiaries[index].happened
                            .validate(),
                        style: const TextStyle(fontSize: 15.0),
                        maxLines: null),
                  ),
                ),
              ],
            ).paddingLeft(10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
            Text(
              "Comments • 100",
              style: TextStyle(fontSize: 12),
            )
              ],
            ).paddingOnly(right: 10, bottom: 3, top: 3),
            const Divider(height: 1, color: Colors.black,),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.comment,
                    size: 18,
                  ).paddingRight(5),
                  const Text('Comment', style: TextStyle(fontSize: 14.0)),
                ],
              ),
            )
          ],
        ),
      ).paddingBottom(20),
      separatorBuilder: (context, index) => Container(),
      itemCount: _getAllDiaryBloc.getAllDiaries.length,
      shrinkWrap: true,
    );
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
              Container(
                child: BlocBuilder<GetAllDiaryBloc, GetAllDiaryState>(
                  bloc: _getAllDiaryBloc,
                  builder: (context, state) {
                    return state is GetAllDiaryLoading
                        ? const Center(child: CircularProgressIndicator())
                        : buildListDiary();
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
