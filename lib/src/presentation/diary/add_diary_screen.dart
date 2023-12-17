import 'package:diary/src/bloc/add_diary_bloc/add_diary_bloc.dart';
import 'package:diary/src/bloc/mood_bloc/mood_bloc.dart';
import 'package:diary/src/models/mood_model.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:diary/styles/text_style.dart';
import 'package:diary/utils/nav_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
    _moodBloc = MoodBloc();
    _moodBloc.getMood();
    _bloc = AddDiaryBloc();
    super.initState();
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

  Widget buildCreateDiary() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<MoodBloc, MoodState>(
      bloc: _moodBloc,
      builder: (context, state) {
        return  Card(
                color: ColorAppStyle.app5,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 2,
                    color: Colors.greenAccent,
                  ),
                  borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Bạn đã trải qua tâm trạng gì: ')),
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
                    ).paddingSymmetric(horizontal: 10).paddingTop(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Mức độ ảnh hưởng tới tâm trạng bạn: ")
                            .paddingLeft(10),
                        Container(
                            height: 30,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            child:
                                buildLevel().paddingSymmetric(horizontal: 4)),
                      ],
                    ),
                    const Text('Bạn đã gặp phải chuyện gì vậy?')
                        .paddingSymmetric(horizontal: 10, vertical: 10),
                    SizedBox(
                      height: height * 0.2,
                      width: width,
                      child: TextField(
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                        controller: happened,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                            fillColor: ColorAppStyle.button,
                            filled: true,
                            hintStyle: TextStyle(fontSize: 14),
                            // border: OutlineInputBorder(),
                            hintText:
                                "Hãy ghi vào đây,\nnhững gì xảy ra khiến tâm trạng bạn thay đổi nhé!"),
                      ),
                    ).paddingSymmetric(horizontal: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Bạn đã ở đâu vào lúc đó?'),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            height: 50,
                            child: TextField(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              controller: place,
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(
                                  fillColor: ColorAppStyle.button,
                                  filled: true,
                                  hintStyle: TextStyle(fontSize: 14),
                                  hintText:
                                      "Trường học, Ở nhà, Cơ quan,...hoặc nơi nào đó"),
                            ))
                      ],
                    ).paddingSymmetric(horizontal: 10, vertical: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                            'Cảm xúc của bạn lúc đó như thế nào?'),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            height: 50,
                            child: TextField(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              controller: moodPast,
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(
                                  fillColor: ColorAppStyle.button,
                                  filled: true,
                                  hintStyle: TextStyle(fontSize: 14),
                                  hintText: "Vui, Buồn, Rối,... hoặc gì đó"),
                            ))
                      ],
                    ).paddingSymmetric(horizontal: 10, vertical: 10),
                    const Text('Thời gian bạn gặp phải chuyện đó: ')
                        .paddingSymmetric(horizontal: 10),
                    SizedBox(
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(
                                enabled: false,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                controller: date,
                                maxLines: null,
                                expands: true,
                                decoration: const InputDecoration(
                                    fillColor: ColorAppStyle.button,
                                    filled: true,
                                    hintText: "Ngày...,tháng...",
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                late final formatter = DateFormat('dd-MM');
                                DateTime? picker = await showDatePicker(
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
                                  date.text = formatter.format(picker!);
                                });
                              },
                              icon: const Icon(Icons.calendar_month_outlined),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                enabled: false,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                controller: time,
                                maxLines: null,
                                expands: true,
                                decoration: const InputDecoration(
                                    fillColor: ColorAppStyle.button,
                                    filled: true,
                                    hintText: "Giờ...",
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                TimeOfDay timeOfDay = TimeOfDay.now();
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: timeOfDay,
                                );
                                if (picked != null) {
                                  setState(() {
                                    time.text =
                                        "${picked.hour}:${picked.minute}";
                                  });
                                } else {
                                  time.text = "";
                                }
                              },
                              icon: const Icon(Icons.calendar_month_outlined),
                            )
                          ],
                        )).paddingSymmetric(horizontal: 10, vertical: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                            'Hãy dành chút thời gian để suy nghĩ về chuyện vừa qua, nếu gặp lại tình huống đó hãy suy nghĩ xem cách giải quyết tốt nhất cho bạn nhé(Hãy ghi xuống bên dưới nhé):'),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            height: 120,
                            child: TextField(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              controller: thinkPast,
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(
                                  fillColor: ColorAppStyle.button,
                                  filled: true,
                                  hintStyle: TextStyle(fontSize: 14),
                                  hintText: "Hãy viết ngắn gọn vào đây..."),
                            ))
                      ],
                    ).paddingSymmetric(horizontal: 10, vertical: 10),
                    Center(
                      child: Text(
                        'Chúng mình sẽ luôn lắng nghe những tâm tư của bạn <3<3',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 1),
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            width: width * 0.35,
                            child: ElevatedButton.icon(
                              onPressed: () async {WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                 await showCupertinoDialog(
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
                                                  style:
                                                      StyleApp.textStyle402()),
                                            ),
                                            CupertinoDialogAction(
                                              isDefaultAction: true,
                                              onPressed: () async {
                                                save();
                                              },
                                              child: Text("Đồng ý",
                                                  style:
                                                      StyleApp.textStyle401()),
                                            ),
                                          ],
                                        );
                                      });
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorAppStyle.app8,
                                side: const BorderSide(
                                    width: 2, color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(
                                Icons.save,
                                size: 14,
                              ),
                              label: const Text('Lưu nhật ký',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            )),
                      ],
                    ).paddingOnly(top: 10, bottom: 5)
                  ],
                ),
              );
      },
    ).paddingSymmetric(horizontal: 5);
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
      NavUtils.pop(context);
      NavUtils.pop(context,
          result: true);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    happened = _bloc.happened;
    thinkPast = _bloc.thinkPast;
    moodPast = _bloc.moodPast;
    date = _bloc.date;
    time = _bloc.time;
    place = _bloc.place;
    //dropdownValue = _bloc.dropdownValue;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorAppStyle.button,
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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorAppStyle.app5,
                ColorAppStyle.app6,
                ColorAppStyle.app2
              ],
            ),
            image: const DecorationImage(
                image: AssetImage("assets/images/shape.png"),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: SingleChildScrollView(child: buildCreateDiary()),
        ),
      ),
    );
  }
}
