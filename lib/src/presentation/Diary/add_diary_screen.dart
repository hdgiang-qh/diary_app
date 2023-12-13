import 'package:diary/src/bloc/add_diary_bloc/add_diary_bloc.dart';
import 'package:diary/src/bloc/mood_bloc/mood_bloc.dart';
import 'package:diary/src/models/mood_model.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:diary/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  TextEditingController place = TextEditingController();
  TextEditingController moodPast = TextEditingController();
  TextEditingController thinkPast = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController date = TextEditingController();
  String? dropdownValue, dropdownLevel;

  @override
  void initState() {
    super.initState();
    _moodBloc = MoodBloc();
    _moodBloc.getMood();
    _bloc = AddDiaryBloc();
  }

  void toastPostComplete(String messenger) => Fluttertoast.showToast(
      msg: "Tạo nhật ký thành công",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  void toastError(String messenger) => Fluttertoast.showToast(
      msg: "Hãy điền đầy đủ thông tin",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  Widget buildDrop() {
    _bloc.dropdownValue = dropdownValue;
    final List<String> list = <String>['PUBLIC', 'PRIVATE'];
    return DropdownButton<String>(
      underline: Container(),
      hint: const Text("Mode"),
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

  Widget buildLevel() {
    _bloc.dropdownLevel = dropdownLevel;
    final List<String> list = <String>[
      'Nhẹ nhàng',
      'Rất ít',
      'Vừa phải',
      'Khá nhiều',
      'Rất nhiều'
    ];
    return DropdownButton<String>(
      hint: const Text("Level"),
      underline: Container(),
      value: dropdownLevel,
      style: const TextStyle(color: primaryColor),
      onChanged: (String? value) {
        setState(() {
          dropdownLevel = value!;
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

  Widget buildDropMood() {
    return DropdownButton(
      hint: const Text("Vui lòng chọn"),
      underline: Container(),
      isExpanded: true,
      value: _moodBloc.moodModel,
      items: _moodBloc.moods
          .map<DropdownMenuItem<MoodModel>>((e) => DropdownMenuItem<MoodModel>(
                value: e,
                child: Text(
                  e.mood ?? "",
                  style: const TextStyle(color: primaryColor),
                ).paddingLeft(10),
              ))
          .toList(),
      onChanged: (MoodModel? moodFeel) {
        setState(() {
          _moodBloc.moodModel = moodFeel;
          _bloc.moodId = moodFeel?.id;
        });
      },
    );
  }

  void save() {
    if (happened.text.isNotEmpty &&
        dropdownValue.toString().isNotEmpty &&
        dropdownLevel.toString().isNotEmpty &&
        time.text.isNotEmpty &&
        moodPast.text.isNotEmpty &&
        thinkPast.text.isNotEmpty &&
        place.text.isNotEmpty &&
        date.text.isNotEmpty) {
      _bloc.createDiary();
      happened.clear();
      dropdownValue = '';
      thinkPast.clear();
      date.clear();
      time.clear();
      moodPast.clear();
      place.clear();
      toastPostComplete("");
      Navigator.of(context).pop();
    } else {
      toastError("");
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    happened = _bloc.happened;
    thinkPast = _bloc.thinkPast;
    moodPast = _bloc.moodPast;
    date = _bloc.date;
    time = _bloc.time;
    place = _bloc.place;
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
        child: SafeArea(
          child: Card(
            // margin: EdgeInsets.only(bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Bạn muốn nhật ký ở chế độ nào? : ")
                            .paddingLeft(10),
                        Container(
                            height: 30,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: buildDrop().paddingSymmetric(horizontal: 4)),
                      ],
                    ).paddingBottom(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Mức độ ảnh hưởng vấn đề đến bạn : ")
                            .paddingLeft(10),
                        Container(
                            height: 30,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child:
                                buildLevel().paddingSymmetric(horizontal: 4)),
                      ],
                    ),
                    Row(
                      children: [
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Cảm xúc hiện tại của bạn : ')),
                        Container(
                          height: 30,
                          padding: const EdgeInsets.only(left: 5),
                          width: 160,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(15)),
                          child: buildDropMood(),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 10, vertical: 10),
                    const Text('Câu chuyện mà bạn gặp phải là gì?')
                        .paddingSymmetric(horizontal: 10, vertical: 10),
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
                            hintText: "Nhập lời bạn muốn nói..."),
                      ),
                    ).paddingSymmetric(horizontal: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Địa điểm nơi bạn bắt đầu câu chuyện đó :'),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            decoration: const BoxDecoration(color: Colors.red),
                            child: TextField(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              controller: place,
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(
                                  fillColor: Colors.orangeAccent,
                                  filled: true,
                                  // border: OutlineInputBorder(),
                                  hintText:
                                      "Trường học, Ở nhà, Cơ quan,... nơi nào đó"),
                            ))
                      ],
                    ).paddingSymmetric(horizontal: 10, vertical: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cảm xúc của bạn lúc đó:'),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            decoration: const BoxDecoration(color: Colors.red),
                            child: TextField(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              controller: moodPast,
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(
                                  fillColor: Colors.orangeAccent,
                                  filled: true,
                                  // border: OutlineInputBorder(),
                                  hintText: "Vui, Buồn, Rối,... hoặc gì đó"),
                            ))
                      ],
                    ).paddingSymmetric(horizontal: 10, vertical: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Lúc đó bạn có suy nghĩ gì:'),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            decoration: const BoxDecoration(color: Colors.red),
                            child: TextField(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              controller: thinkPast,
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(
                                  fillColor: Colors.orangeAccent,
                                  filled: true,
                                  // border: OutlineInputBorder(),
                                  hintText: "Hãy viết ngắn gọn..."),
                            ))
                      ],
                    ).paddingSymmetric(horizontal: 10, vertical: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Thời gian bạn gặp phải chuyện đó: '),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            decoration: const BoxDecoration(color: Colors.red),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: TextField(
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                    controller: date,
                                    maxLines: null,
                                    expands: true,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: () async {
                                            late final formatter =
                                                DateFormat('dd-MM');
                                            DateTime? picker =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime(2025));
                                            if (picker != null) {
                                              setState(() {
                                                date.clear();
                                              });
                                            }
                                            setState(() {
                                              date.text =
                                                  "ngày ${formatter.format(picker!)}";
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.calendar_month_outlined),
                                        ),
                                        fillColor: Colors.orangeAccent,
                                        filled: true,
                                        // border: OutlineInputBorder(),
                                        hintText: "Ngày...,giờ..."),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextField(
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                    controller: time,
                                    maxLines: null,
                                    expands: true,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: () async {
                                            TimeOfDay timeOfDay =
                                                TimeOfDay.now();
                                            final TimeOfDay? picked =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: timeOfDay,
                                            );
                                            if (picked != null) {
                                              setState(() {
                                                time.text =
                                                    "${picked?.hour}:${picked?.minute}";
                                              });
                                            } else {
                                              time.text = "";
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.calendar_month_outlined),
                                        ),
                                        fillColor: Colors.orangeAccent,
                                        filled: true,
                                        // border: OutlineInputBorder(),
                                        hintText: "Ngày...,giờ..."),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ).paddingSymmetric(horizontal: 10, vertical: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            width: width * 0.3,
                            child: ElevatedButton(
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
                                              'Xác nhận tạo nội dung Diary?',
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: [
                                              CupertinoDialogAction(
                                                isDefaultAction: true,
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("Huỷ",
                                                    style: StyleApp
                                                        .textStyle402()),
                                              ),
                                              CupertinoDialogAction(
                                                isDefaultAction: true,
                                                onPressed: () async {
                                                  save();
                                                },
                                                child: Text("Đồng ý",
                                                    style: StyleApp
                                                        .textStyle401()),
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
        ),
      ),
    );
  }
}
