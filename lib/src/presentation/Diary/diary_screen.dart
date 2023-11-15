import 'package:diary/src/bloc/num_bloc.dart';
import 'package:diary/src/presentation/Diary/add_diary_screen.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:diary/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../bloc/diaryUser_bloc/diaryuser_bloc.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final NumBloc numBloc = NumBloc();
//  late final date = DateTime.now().subtract(const Duration(days: 30));
  late final date = DateTime.now();
  late final formatter = DateFormat('dd/MM/yyyy');
  late String startDate = formatter.format(date);
  String? _startDate;
  late final DiaryUserBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = DiaryUserBloc();
    _bloc.getListDU();
  }

  Widget buildTimeDate() {
    return Container(
      height: 50,
      width: 170,
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: BlocBuilder<NumBloc, int>(
        bloc: numBloc,
        builder: (context, state) {
          return Container(
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: radius(10),
              border: Border.all(color: ColorAppStyle.greyD8, width: 1),
              backgroundColor: white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            width: double.infinity,
            child: Text(
                _startDate == null
                    ? '$startDate'
                    : '$_startDate',
                style: StyleApp.textDate()),
          );
        },
      ).onTap(() {
        showDateRangePicker(
          context: context,
          firstDate: DateTime(2015),
          lastDate: DateTime(2025),
        ).then((value) {
          // if (value != null) {
          //   _topSaleBloc.startTime = _startDate;
          //   _revenueBloc.startTime = _startDate;
          //   _topAccumulationBloc.startTime = _startDate;
          //   _topProductBloc.startTime = _startDate;
          //
          //   endDate = value.end.toDateTimeStringWithoutHour();
          //   _endDate = value.end.toDateTimeStringWithoutHour();
          //   _topSaleBloc.endTime = _endDate;
          //   _revenueBloc.endTime = _endDate;
          //   _topAccumulationBloc.endTime = _endDate;
          //   _topProductBloc.endTime = _endDate;
          //   numBloc.changeNum(
          //     Random().nextInt(10000),
          //   );
          //   _topSaleBloc.topSale.clear();
          //   _topAccumulationBloc.topAccumulation.clear();
          //   _revenueBloc.revenueModel?.toMap().clear();
          //   _revenueBloc.getRevenueChart();
          //   _topSaleBloc.getTopSale();
          //   _topAccumulationBloc.getTopAccumulation();
          //   _topProductBloc.list.clear();
          //   _topProductBloc.getTopProduct();
          // }
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Your Diary"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddDiaryScreen()));
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                buildTimeDate(),
                Container(
                  child: BlocBuilder<DiaryUserBloc, DiaryuserState>(
                    bloc: _bloc,
                    builder: (context, state) {
                      if (_bloc.listDU.isEmpty) {
                        return const
                        //  CircularProgressIndicator();
                        Center(
                          child: Text("Loading Data..."),
                        );
                      }
                      return state is DiaryUserLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              width: double.infinity,
                              height: 300,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex:2,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                _bloc
                                                    .listDU[index].nickname
                                                    .validate()
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Expanded(child: Text(_bloc.listDU[index].status.toString()))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ).paddingAll(5),
                                  SingleChildScrollView(
                                    child: SizedBox(
                                      child: Text(
                                          _bloc
                                              .listDU[index].happened
                                              .validate(),
                                          style: const TextStyle(
                                              fontSize: 15.0),
                                          maxLines: null),
                                    ),
                                  ).paddingLeft(5),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                // crossAxisAlignment:
                                //     CrossAxisAlignment.center,
                                children: [
                                  Text('Comment',
                                      style: TextStyle(fontSize: 14.0)),
                                ],
                              ),
                            )
                          ],
                        ).paddingBottom(20),
                        separatorBuilder: (context, index) => Container(),
                        itemCount: _bloc.listDU.length,
                        shrinkWrap: true,
                      );
                    },
                  ).paddingSymmetric(horizontal: 10),
                )
              ],
            ),
          ).paddingSymmetric(horizontal: 5),
        ));
  }
}
