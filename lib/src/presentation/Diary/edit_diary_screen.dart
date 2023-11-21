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
  late final MoodBloc _moodBloc;
  TextEditingController happened = TextEditingController();
  String? dropdownValue;
  late final DiaryUserBloc _bloc;

  @override
  void initState() {
    super.initState();
    _moodBloc = MoodBloc();
    _moodBloc.getMood();
    _detailDiaryBloc = DetailDiaryBloc();
    _bloc = DiaryUserBloc();
  }

  // Widget buildMood() {
  //   final height = MediaQuery.of(context).size.height;
  //   final width = MediaQuery.of(context).size.width;
  //   return SingleChildScrollView(
  //     child: Container(
  //       child: BlocBuilder<MoodBloc, MoodState>(
  //         bloc: _moodBloc,
  //         builder: (context, state) {
  //           return state is MoodLoading
  //               ? const Center(child: CircularProgressIndicator())
  //               : GridView.builder(
  //                   padding: const EdgeInsets.symmetric(vertical: 5),
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   itemBuilder: (context, index) => Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Container(
  //                         decoration: BoxDecoration(
  //                             border: Border.all(),
  //                             borderRadius:
  //                                 const BorderRadius.all(Radius.circular(5))),
  //                         child: Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               _moodBloc.mood[index].id.validate().toString(),
  //                               style: const TextStyle(fontSize: 12),
  //                             ).paddingAll(5),
  //                             Text(
  //                               _moodBloc.mood[index].mood
  //                                   .validate()
  //                                   .toString(),
  //                               style: const TextStyle(fontSize: 12),
  //                             ).paddingAll(5),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   //separatorBuilder: (context, index) => Container(),
  //                   itemCount: _moodBloc.mood.length,
  //                   shrinkWrap: true,
  //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                       crossAxisCount: 3,
  //                       childAspectRatio: width / (height / 7),
  //                       crossAxisSpacing: 5.0,
  //                       mainAxisSpacing: 5.0),
  //                 );
  //         },
  //       ).paddingSymmetric(horizontal: 10),
  //     ),
  //   );
  // }

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
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return BlocBuilder<DetailDiaryBloc, DetailDiaryState>(
        bloc: _detailDiaryBloc..add(GetIdDiary(id: widget.id)),
        builder: (context, state) {
          if (state is DetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DetailFailure) {
            return ItemLoadFail(
                msg: state.er,
                onRefresh: () {
                  _detailDiaryBloc.add(GetIdDiary(id: widget.id));
                });
          } else if (state is DetailSuccessV2) {
            happened.text =
                _detailDiaryBloc.model!.happened.validate().toString();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Mood Feel : ${_detailDiaryBloc.model!.mood
                            .validate()}"),
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
                ).paddingSymmetric(horizontal: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: width * 0.3,
                        child: ElevatedButton(
                            onPressed: () {
                              updateDiary(
                                  _detailDiaryBloc.model!.id.validate());
                            },
                            child: const Text("Save"))),
                  ],
                ).paddingTop(15)
              ],
            );
          } else {
            return Container();
          }
        });
  }

  void toastEditComplete(String messenger) =>
      Fluttertoast.showToast(
          msg: "Update Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white);

  Future<void> updateDiary(int id) async {
    final happen = happened.text;
    final statuses = dropdownValue;
    try {
      Map<String, dynamic> data = {
        'happened': happen,
        'status': statuses,
      };
      final res = await Api.putAsync(
        endPoint: "${ApiPath.curdDiary}/$id",
        req: data,
      );
      if (happen.isEmpty || dropdownValue
          .toString()
          .isEmpty) {
        return;
      } else if (res['status'] == "SUCCESS") {
        return toastEditComplete("");
      } else {
        // Xử lý lỗi
        print('Fail: ${res.statusCode}');
        print(res.data);
        return;
      }
    } on DioException catch (e) {
      // Xử lý lỗi Dio
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Hãy điền đầy đủ thông tin'),
      ));
      print('Lỗi Dio: ${e.error}');
    } catch (e) {
      // Xử lý lỗi khác
      print('Lỗi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            _bloc.listDU.clear();
            _bloc.getListDU();
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
      ),
    );
  }
}
