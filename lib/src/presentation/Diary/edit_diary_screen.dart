import 'package:diary/src/bloc/detail_diary/detail_diary_bloc.dart';
import 'package:diary/styles/color_styles.dart';
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
      value: status,
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
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Cảm xúc : ${_detailDiaryBloc.model!.mood.validate()}"),
                        Row(
                          children: [
                            const Text("Chế độ nhật ký : "),
                            buildDrop(),
                          ],
                        )
                      ],
                    ).paddingSymmetric(horizontal: 10),
                    const Text("Chỉnh sửa câu chuyện :").paddingLeft(10),
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
                                  if (happened.text.isNotEmpty) {
                                    _detailDiaryBloc.updateDiary(
                                        _detailDiaryBloc.model!.id.validate());
                                    happened.clear();
                                    Navigator.of(context).pop();
                                    toastEditComplete("");
                                  }
                                  else{
                                    toastEditFailure("");
                                  }
                                },
                                child: const Text("Save"))),
                      ],
                    ).paddingSymmetric(vertical: 10)
                  ],
                ),
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

  void toastEditFailure(String messenger) => Fluttertoast.showToast(
      msg: "Update Failure",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  _getRequests() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorAppStyle.purple8a,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Edit Diary"),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorAppStyle.purple6f,
                ColorAppStyle.purple8a,
                ColorAppStyle.blue75
              ],
            ),
            image: DecorationImage(
                image: AssetImage("assets/images/shape.png"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              buildIdDiary(),
            ],
          ),
        ).paddingOnly(top: 5),
      ),
    );
  }
}
