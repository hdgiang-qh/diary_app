import 'package:diary/src/bloc/detail_diary/detail_diary_bloc.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:diary/styles/text_style.dart';
import 'package:diary/utils/nav_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_toast/motion_toast.dart';
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
  TextEditingController place = TextEditingController();
  TextEditingController moodPast = TextEditingController();
  TextEditingController thinkPast = TextEditingController();
  String? dropdownLevel;

  @override
  void initState() {
    super.initState();
    _detailDiaryBloc = DetailDiaryBloc(widget.id);
    _detailDiaryBloc.getDetailDiary(widget.id);
  }
@override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }
  Widget buildLevel() {
    String level = _detailDiaryBloc.model!.level.validate().toString();
    final List<String> list = <String>[
      'Nhẹ nhàng',
      'Rất ít',
      'Vừa phải',
      'Khá nhiều',
      'Rất nhiều'
    ];
    return DropdownButton<String>(
      hint: Text(level),
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

  Widget buildIdDiary() {
    _detailDiaryBloc.happen = happened;
    _detailDiaryBloc.moodPast = moodPast;
    _detailDiaryBloc.place = place;
    _detailDiaryBloc.thinkPast = thinkPast;
    _detailDiaryBloc.dropdownLevel = dropdownLevel;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<DetailDiaryBloc, DetailDiaryState>(
        bloc: _detailDiaryBloc,
        builder: (context, state) {
          if (state is DetailFailure) {
            return Center(
              child: Text(state.er.toString()),
            );
          } else if (state is DetailSuccessV2) {
            happened.text =
                _detailDiaryBloc.model!.happened.validate().toString();
            place.text = _detailDiaryBloc.model!.place.validate();
            moodPast.text = _detailDiaryBloc.model!.thinkingFelt.validate();
            thinkPast.text = _detailDiaryBloc.model!.thinkingMoment.validate();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cảm xúc : ${_detailDiaryBloc.model!.mood.validate()}",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          letterSpacing: .5),
                    )).paddingSymmetric(horizontal: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("Mức độ ảnh hương tới tâm trạng bạn: ")
                        .paddingLeft(10),
                    Container(
                        height: 30,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: buildLevel().paddingSymmetric(horizontal: 4)),
                  ],
                ),
                const Text('Chỉnh sửa câu chuyện mà bạn gặp phải:')
                    .paddingSymmetric(horizontal: 10),
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
                        fillColor: ColorAppStyle.button,
                        filled: true,
                        // border: OutlineInputBorder(),
                        hintText: "Nhập lời bạn muốn nói..."),
                  ),
                ).paddingSymmetric(horizontal: 10, vertical: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Địa điểm nơi bạn bắt đầu câu chuyện đó :'),
                    SizedBox(
                        height: 50,
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                          controller: place,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                              fillColor: ColorAppStyle.button,
                              filled: true,
                              // border: OutlineInputBorder(),
                              hintText:
                                  "Trường học, Ở nhà, Cơ quan,... nơi nào đó"),
                        ))
                  ],
                ).paddingSymmetric(horizontal: 10, vertical: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cảm xúc của bạn lúc đó:'),
                    SizedBox(
                        height: 50,
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                          controller: moodPast,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                              fillColor: ColorAppStyle.button,
                              filled: true,
                              hintText: "Vui, Buồn, Rối,... hoặc gì đó"),
                        ))
                  ],
                ).paddingSymmetric(horizontal: 10, vertical: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cách giải quyết sau khi suy nghĩ lại:'),
                    SizedBox(
                        height: 120,
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                          controller: thinkPast,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                              fillColor: ColorAppStyle.button,
                              filled: true,
                              // border: OutlineInputBorder(),
                              hintText: "Hãy viết ngắn gọn..."),
                        ))
                  ],
                ).paddingSymmetric(horizontal: 10, vertical: 5),
                Text(
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              letterSpacing: .5),
                        ),
                        "ngày ${_detailDiaryBloc.model!.date.validate()}, lúc ${_detailDiaryBloc.model!.time.validate()} ")
                    .paddingSymmetric(horizontal: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: width * 0.35,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: const Icon(
                                        CupertinoIcons.info_circle,
                                      ),
                                      content: const Text(
                                        'Bạn có thay đổi nhật ký này?',
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        CupertinoDialogAction(
                                          isDefaultAction: true,
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text("Cancel",
                                              style: StyleApp.textStyle401()),
                                        ),
                                        CupertinoDialogAction(
                                          isDefaultAction: true,
                                          onPressed: () {
                                            if (happened.text.isNotEmpty &&
                                                place.text.isNotEmpty &&
                                                thinkPast.text.isNotEmpty &&
                                                moodPast.text.isNotEmpty &&
                                                dropdownLevel
                                                    .toString()
                                                    .isNotEmpty) {
                                              _detailDiaryBloc.updateDiary(
                                                  _detailDiaryBloc.model!.id
                                                      .validate());
                                              NavUtils.pop(context);
                                              NavUtils.pop(context,
                                                  result: true);
                                            } else {
                                              Navigator.of(context).pop();
                                              ToastUpdateError();
                                            }
                                          },
                                          child: Text("Apply",
                                              style: StyleApp.textStyle402()),
                                        ),
                                      ],
                                    );
                                  });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorAppStyle.app8,
                            side:
                                const BorderSide(width: 2, color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(
                            Icons.save,
                            size: 14,
                          ),
                          label: const Text('Lưu Thay Đổi',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        )),
                  ],
                ).paddingSymmetric(vertical: 10)
              ],
            );
          } else {
            return Container();
          }
        });
  }


  void ToastUpdateError() {
    MotionToast(
      icon: Icons.error_outline,
      primaryColor: Colors.red[400]!,
      secondaryColor: Colors.grey,
      backgroundType: BackgroundType.solid,
      title: const Text(
        'Chỉnh sửa không thành công',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('Hãy kiểm tra lại thông tin'),
      position: MotionToastPosition.top,
      animationType: AnimationType.fromRight,
      animationDuration: const Duration(seconds: 2),
      width: 300,
      height: 50,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text("Chỉnh sửa nhật ký"),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorAppStyle.app5,
                ColorAppStyle.app6,
                ColorAppStyle.app2
              ],
            ),
            image: DecorationImage(
                image: AssetImage("assets/images/shape.png"),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Card(
              color: ColorAppStyle.app5,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 2,
                  color: Colors.greenAccent,
                ),
                borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildIdDiary(),
                ],
              ).paddingOnly(top: 5),
            ),
          ),
        ),
      ),
    );
  }
}
