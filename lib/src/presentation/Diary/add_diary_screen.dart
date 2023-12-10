import 'package:diary/src/bloc/add_diary_bloc/add_diary_bloc.dart';
import 'package:diary/src/bloc/mood_bloc/mood_bloc.dart';
import 'package:diary/src/models/mood_model.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:diary/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class AddDiaryScreen extends StatefulWidget {
  const AddDiaryScreen({super.key});

  @override
  State<AddDiaryScreen> createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  late final MoodBloc _moodBloc;
  late final AddDiaryBloc _bloc;
  TextEditingController happened = TextEditingController();
  TextEditingController mood = TextEditingController();
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    _bloc = AddDiaryBloc();
    _moodBloc = MoodBloc();
    _moodBloc.getMood();
  }

  void toastPostComplete(String messenger) => Fluttertoast.showToast(
      msg: "Post Success",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  void toastError(String messenger) => Fluttertoast.showToast(
      msg: "Please fill in all information",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  Widget buildMood() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<MoodBloc, MoodState>(
      bloc: _moodBloc,
      builder: (context, state) {
        return state is MoodLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _moodBloc.mood[index].id.validate().toString(),
                            style: const TextStyle(fontSize: 12),
                          ).paddingAll(5),
                          Text(
                            _moodBloc.mood[index].mood.validate().toString(),
                            style: const TextStyle(fontSize: 12),
                          ).paddingAll(5),
                        ],
                      ),
                    ),
                  ],
                ),
                itemCount: _moodBloc.mood.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: width / (height / 7),
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0),
              );
      },
    ).paddingSymmetric(horizontal: 10);
  }

  Widget buildDrop(BuildContext context) {
    _bloc.dropdownValue = dropdownValue;
    final List<String> list = <String>['PUBLIC', 'PRIVATE'];
    return DropdownButton<String>(
      hint: const Text("Select Status"),
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    happened = _bloc.happened;
    mood = _bloc.mood;

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
        title: const Text("Tạo nhật ký"),
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
        child: Card(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Status Mode : "),
                    buildDrop(context).paddingRight(10),
                  ],
                ),
                SizedBox(
                  height: height * 0.2,
                  width: width,
                  child: TextField(
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    controller: happened,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                        fillColor: Colors.orangeAccent,
                        filled: true,
                        // border: OutlineInputBorder(),
                        hintText: "Bạn đang cảm thấy thế nào?"),
                  ),
                ).paddingSymmetric(horizontal: 10),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("List Feel Can :"),
                      buildMood(),
                    ],
                  ).paddingSymmetric(horizontal: 10),
                ),
                Row(
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Cảm xúc hiện tại : ')),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.only(left: 5),
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)),
                      child: DropdownButton(
                        hint: const Text("Vui lòng chọn",
                            style: TextStyle(fontSize: 16)),
                        underline: Container(),
                        isExpanded: true,
                        value: _moodBloc.moodModel,
                        items: _moodBloc.mood
                            .map<DropdownMenuItem<MoodModel>>(
                                (e) => DropdownMenuItem<MoodModel>(
                                      value: e,
                                      child: Text(e.mood ?? ""),
                                    ))
                            .toList(),
                        onChanged: (MoodModel? mood) {
                          setState(() {
                            _moodBloc.moodModel = mood;
                            _bloc.moodId = mood?.id;
                          });
                        },
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: width * 0.3,
                        child: ElevatedButton(
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Icon(
                                            CupertinoIcons.info_circle),
                                        content: const Text(
                                          'Xác nhận tạo nội dung Diary?',
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("Huỷ",
                                                style: StyleApp.textStyle402()),
                                          ),
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            onPressed: () async {
                                              if (_bloc.happened.text
                                                      .isNotEmpty &&
                                                  _bloc.dropdownValue
                                                      .toString()
                                                      .isNotEmpty) {
                                                _bloc.createDiary();
                                                happened.clear();
                                                dropdownValue = '';
                                                toastPostComplete("");
                                                Navigator.of(context).pop();
                                              } else {
                                                toastError("");
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: Text("Đồng ý",
                                                style: StyleApp.textStyle401()),
                                          ),
                                        ],
                                      );
                                    });
                              });
                            },
                            child: const Text("Save"))),
                  ],
                ).paddingOnly(top: 10, bottom: 5)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
