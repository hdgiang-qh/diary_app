import 'package:diary/src/bloc/detail_diary/detail_diary_bloc.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class DetailDiaryScreen extends StatefulWidget {
  final int id;

  const DetailDiaryScreen({super.key, required this.id});

  @override
  State<DetailDiaryScreen> createState() => _DetailDiaryScreenState();
}

class _DetailDiaryScreenState extends State<DetailDiaryScreen> {
  late final DetailDiaryBloc _bloc;
  String? lvl;

  @override
  void initState() {
    _bloc = DetailDiaryBloc(widget.id);
    _bloc.getDetailDiary(widget.id);
    super.initState();
  }

  Color getLevelColor(String level) {
    switch (level) {
      case "Nhẹ nhàng":
        return Colors.green;
      case "Rất ít":
        return Colors.yellow;
      case "Vừa phải":
        return Colors.orange;
      case "Khá nhiều":
        return Colors.redAccent;
      case "Rất nhiều":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget buildDetailDiary() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<DetailDiaryBloc, DetailDiaryState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is DetailLoading) {
            return  Center(
              child: const CircularProgressIndicator().paddingTop(20),
            );
          } else if (state is DetailFailure) {
            return Center(
              child: Text(state.er.toString()),
            );
          } else if (state is DetailSuccessV2) {
            lvl = _bloc.model!.level.validate();
            Color level = getLevelColor(_bloc.model!.level.validate());
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Text('Chọn chế độ nhật ký'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: width * 0.36,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  _bloc.setPublicDiary(_bloc.model!.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorAppStyle.app8,
                                  side: const BorderSide(
                                      width: 2, color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: Container(),
                                label: const Text('Chế độ Public',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.36,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  _bloc.setPrivateDiary(_bloc.model!.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorAppStyle.app8,
                                  side: const BorderSide(
                                      width: 2, color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: Container(),
                                label: const Text('Chế đố Private',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Cảm xúc : ${_bloc.model!.mood.validate()}"),
                      Row(
                        children: [
                          const Text("Chế độ nhật ký : "),
                          Text(
                            _bloc.model!.status.validate(),
                            style: TextStyle(
                                color:
                                    _bloc.model!.status.toString() == "PUBLIC"
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Mức độ ảnh hưởng tới tâm trạng bạn: ",
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                letterSpacing: .5),
                          )),
                      Text(
                        lvl!,
                        style: TextStyle(
                            color: level, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Câu chuyện mà bạn gặp phải:',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            letterSpacing: .5),
                      )),
                  SizedBox(
                    width: width,
                    child: Text(_bloc.model!.happened.validate(),
                        style: const TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Địa điểm nơi bạn bắt đầu câu chuyện đó :',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            letterSpacing: .5),
                      )),
                  SizedBox(
                    width: width,
                    child: Text(_bloc.model!.place.validate(),
                        style: const TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Cảm xúc,suy nghĩ của bạn lúc đó:',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            letterSpacing: .5),
                      )),
                  SizedBox(
                    width: width,
                    child: Text(_bloc.model!.thinkingFelt.validate(),
                        style: const TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Cách giải quyết sau khi suy nghĩ lại:',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            letterSpacing: .5),
                      )),
                  SizedBox(
                    width: width,
                    child: Text(_bloc.model!.thinkingMoment.validate(),
                        style: const TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            letterSpacing: .5),
                      ),
                      "ngày ${_bloc.model!.date.validate()}, lúc ${_bloc.model!.time.validate()} "),
                  const SizedBox(
                    height: 10,
                  ),


                ],
              ).paddingSymmetric(horizontal: 10, vertical: 5),
            ).paddingTop(10);
          } else {
            return Container();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chi tiết nhật ký'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
            child: buildDetailDiary(),
          ),
        ),
      ),
    );
  }
}
