import 'package:diary/src/bloc/detail_diary/detail_diary_bloc.dart';
import 'package:diary/src/bloc/diaryUser_bloc/diaryuser_bloc.dart';
import 'package:diary/src/bloc/mood_bloc/mood_bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/presentation/widget/item_load_fail.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class EditDiaryScreen extends StatefulWidget {
  final int id;

  const EditDiaryScreen({super.key, required this.id});

  @override
  State<EditDiaryScreen> createState() => _EditDiaryScreenState();
}

class _EditDiaryScreenState extends State<EditDiaryScreen> {
  late final DetailDiaryBloc _detailDiaryBloc;
  TextEditingController happened = TextEditingController();
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    _detailDiaryBloc = DetailDiaryBloc(widget.id);
    _detailDiaryBloc.getDetailDiary(widget.id);
  }

  Widget buildDrop() {
    List<String> list = <String>['PUBLIC', 'PRIVATE'];
    String status = _detailDiaryBloc.model!.status.validate().toString();
    return DropdownButton<String>(
      hint: Text(status),
      value: dropdownValue,
      style: const TextStyle(color: primaryColor),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String stt) {
        return DropdownMenuItem<String>(
          value: stt,
          child: Text(stt),
        );
      }).toList(),
    );
  }

  Widget buildIdDiary() {
    _detailDiaryBloc.happen = happened;
    _detailDiaryBloc.status.text = dropdownValue.toString();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<DetailDiaryBloc, DetailDiaryState>(
        bloc: _detailDiaryBloc,
        builder: (context, state) {
          if (state is DetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DetailFailure) {
            return Center(
              child: Text(state.er.toString()),
            );
          } else if (state is DetailSuccessV2) {
            happened.text =
                _detailDiaryBloc.model!.happened.validate().toString();
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Mood Feel : ${_detailDiaryBloc.model!.mood.validate()}"),
                      Row(
                        children: [
                          const Text("Status Mode : "),
                          buildDrop(),
                        ],
                      )
                    ],
                  ).paddingSymmetric(horizontal: 10),
                  SizedBox(
                    height: height * 0.2,
                    width: width,
                    child: TextField(
                      controller: happened,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                          filled: true,
                          // border: OutlineInputBorder(),
                          hintText: "How are you feeling now?"),
                    ),
                  ).paddingSymmetric(horizontal: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          width: width * 0.3,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_detailDiaryBloc.status.text.isNotEmpty &&
                                    _detailDiaryBloc.happen.text.isNotEmpty) {
                                  _detailDiaryBloc.updateDiary(
                                      _detailDiaryBloc.model!.id.validate());
                                  toastEditComplete("");
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text("Save"))),
                    ],
                  ).paddingTop(15)
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  void toastEditComplete(String messenger) => Fluttertoast.showToast(
      msg: "Update Success",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Edit Diary"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            buildIdDiary(),
          ],
        ),
      ).paddingOnly(top: 5),
    );
  }
}
