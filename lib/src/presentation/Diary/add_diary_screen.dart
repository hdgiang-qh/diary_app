import 'package:diary/src/bloc/add_diary_bloc/add_diary_bloc.dart';
import 'package:diary/src/bloc/mood_bloc/mood_bloc.dart';
import 'package:diary/styles/color_styles.dart';
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

  Widget buildMood() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        // color: Colors.red,
        child: BlocBuilder<MoodBloc, MoodState>(
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
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
                          if (_bloc.happened.text.isNotEmpty &&
                              _bloc.mood.text.isNotEmpty &&
                              _bloc.dropdownValue.toString().isNotEmpty){
                            _bloc.createDiary();
                            happened.clear();
                            mood.clear();
                            dropdownValue= '';
                            Navigator.of(context).pop();
                          }
                          else {
                            String err = "Value is not Empty";
                          }

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
