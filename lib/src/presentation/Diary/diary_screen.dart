import 'package:diary/src/bloc/num_bloc.dart';
import 'package:diary/src/presentation/Diary/add_diary_screen.dart';
import 'package:diary/src/presentation/Diary/edit_diary_screen.dart';
import 'package:diary/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

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

  Widget buildListDiary() {
    return Container(
      child: BlocBuilder<DiaryUserBloc, DiaryuserState>(
        bloc: _bloc,
        builder: (context, state) {
          return state is DiaryUserLoading
              ? const Center(child: CircularProgressIndicator())
              : (_bloc.listDU.isEmpty
                  ? const Center(
                      child: Text("Not Value"),
                    )
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(_bloc.listDU[index].status
                                            .toString())),
                                  ],
                                ).paddingAll(5),
                                SingleChildScrollView(
                                  child: SizedBox(
                                    child: Text(
                                        _bloc.listDU[index].happened.validate(),
                                        style: const TextStyle(fontSize: 15.0),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // crossAxisAlignment:
                              //     CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {},
                                    child: const Text("Set Status")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditDiaryScreen(
                                                      id: _bloc.listDU[index].id
                                                          .validate())));
                                    },
                                    child: const Text("Edit Diary")),
                                ElevatedButton(
                                    onPressed: () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        showCupertinoDialog(
                                            context: context,
                                            builder: (context) {
                                              return CupertinoAlertDialog(
                                                title: const Icon(
                                                    CupertinoIcons.info_circle),
                                                content: const Text(
                                                  'Do you want to remove this diary from the list?',
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    isDefaultAction: true,
                                                    onPressed: () =>
                                                        Navigator.pop(context),
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
                                    child: const Icon(Icons.delete_forever)),
                              ],
                            ).paddingSymmetric(vertical: 5),
                          )
                        ],
                      ).paddingBottom(20),
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
                  // _bloc.listDU.clear();
                  // _bloc.getListDU();
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
              children: <Widget>[buildDate(), buildListDiary()],
            ),
          ).paddingSymmetric(horizontal: 5),
        ));
  }
}
