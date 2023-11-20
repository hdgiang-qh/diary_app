import 'package:diary/src/bloc/diaryUser_bloc/diaryuser_bloc.dart';
import 'package:diary/src/bloc/mood_bloc/mood_bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/core/const.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:diary/styles/text_style.dart';
import 'package:dio/dio.dart';
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
  late final DiaryUserBloc bloc;
  Dio dio = Dio();
  TextEditingController happened = TextEditingController();
  TextEditingController mood = TextEditingController();
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    _moodBloc = MoodBloc();
    _moodBloc.getMood();
  }

  Widget buildMood() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        // color: Colors.red,
        child: BlocBuilder<MoodBloc, MoodState>(
          bloc: _moodBloc,
          builder: (context, state) {
            // if (_moodBloc.mood.isEmpty) {
            //   return const
            //       //  CircularProgressIndicator();
            //       Center(
            //     child: Text("Loading Data..."),
            //   );
            // }
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
                                _moodBloc.mood[index].mood
                                    .validate()
                                    .toString(),
                                style: const TextStyle(fontSize: 12),
                              ).paddingAll(5),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //separatorBuilder: (context, index) => Container(),
                    itemCount: _moodBloc.mood.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: width / (height / 7),
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0),
                  );
          },
        ).paddingSymmetric(horizontal: 10),
      ),
    );
  }

  Widget buildDrop(BuildContext context) {
    final List<String> list = <String>['PUBLIC', 'PRIVATE'];
    return DropdownButton<String>(
      hint: const Text("Select Status"),
      value: dropdownValue,
      style: const TextStyle(color: primaryColor),
      onChanged: (String? value) {
        // This is called when the user selects an item.
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

  Future<void> createDiary() async {
    final happen = happened.text;
    final moodId = mood.text;
    final statuses = dropdownValue;
    try {
      Map<String, dynamic> data = {
        'happened': happen,
        'moodId': moodId,
        'status': statuses,
      };
      final res = await Api.postAsync(
        endPoint: ApiPath.curdDiary,
        req: data,
      );
      if (happen.isEmpty || moodId.isEmpty || dropdownValue.toString().isEmpty) {
        return;
      } else if (res['status'] == "SUCCESS") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Post Success!'),
        ));
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            bloc = DiaryUserBloc();
            bloc.listDU.clear();
            bloc.getListDU();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("New A Diary"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Status Mode : "),
                buildDrop(context).paddingRight(10),
              ],
            ),
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
            SizedBox(
              height: height * 0.15,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("List Feel Can :"),
                  buildMood(),
                ],
              ),
            ).paddingSymmetric(horizontal: 10),
            Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    const Text("Mood Feel : "),
                    SizedBox(
                      height: 35,
                      width: 70,
                      child: TextField(
                        controller: mood,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Num?",
                          hintStyle: TextStyle(fontSize: 14),
                          isDense: true,
                        ),
                      ),
                    )
                  ],
                )),
              ],
            ).paddingSymmetric(horizontal: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: width * 0.3,
                    child: ElevatedButton(
                        onPressed: () {
                          createDiary();
                        },
                        child: const Text("Save"))),
              ],
            ).paddingTop(15)
          ],
        ),
      ),
    );
  }
}
