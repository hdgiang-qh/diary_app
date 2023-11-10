import 'package:diary/src/bloc/mood_bloc/mood_bloc.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _moodBloc = MoodBloc();
    _moodBloc.getMood();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("New A Diary"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: height * 0.2,
              width: width,
              child: const TextField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
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
                                      CupertinoIcons.heart_fill,
                                     // color: Colors.pink,
                                    ),
                                    content: const Text(
                                      'Do you want to post this content?',
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Huỷ",
                                            style: StyleApp.textStyle400()),
                                      ),
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Đồng ý",
                                            style: StyleApp.textStyle400()),
                                      ),
                                    ],
                                  );
                                });
                          });
                        },
                        child: const Text("Share"))),
                SizedBox(
                    width: width * 0.3,
                    child: ElevatedButton(
                        onPressed: () {}, child: const Text("Save"))),
              ],
            )
          ],
        ),
      ),
    );
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
            if (_moodBloc.mood.isEmpty) {
              return const
                  //  CircularProgressIndicator();
                  Center(
                child: Text("Loading Data..."),
              );
            }
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
}
