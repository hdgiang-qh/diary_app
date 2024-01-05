import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:diary/src/bloc/chart_bloc/chart_bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/service/provider_token.dart';
import 'package:diary/src/models/chart_model.dart';
import 'package:diary/src/presentation/Auth/ChangePass/change_pass.dart';
import 'package:diary/src/presentation/Auth/Infor/change_avatar.dart';
import 'package:diary/src/presentation/auth/infor/change_infor.dart';
import 'package:diary/src/presentation/widget/common_widget.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:diary/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class SalesData {
  final String month;
  final int sales;

  SalesData(this.month, this.sales);
}

class _InformationState extends State<Information> {
  late final InforBloc _bloc;
  late final ChartBloc _chartBloc;
  late Future<ChartMonthModel> _data;

  @override
  void initState() {
    _chartBloc = ChartBloc();
    //_chartBloc.getData();
    _data = _chartBloc.fetchData();
    _bloc = InforBloc();
    _bloc.getInforUser();
    super.initState();
  }

  void toastCreateComplete(String messenger) => Fluttertoast.showToast(
      msg: "Cập nhật thành công",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  Widget buildInfor() {
    return BlocBuilder<InforBloc, InforState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is InforSuccess2) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(state.ifUser.avatar
                                      .validate()
                                      .toString()),
                                  fit: BoxFit.cover)),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.image_outlined,
                                    size: 14,
                                  ),
                                  onPressed: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChangeAvatarScreen()));
                                    _bloc.refreshPage();
                                  },
                                )),
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Tên người dùng : ${state.ifUser.nickName.validate()}"),
                          Text(
                              "Số điện thoại : ${state.ifUser.phone.validate()}"),
                          Text(
                              "Tuổi : ${state.ifUser.age.validate().toString()}"),
                          Text("Email : ${state.ifUser.email.validate()}")
                        ],
                      )
                    ],
                  ),
                ],
              ).paddingTop(15),
            );
          } else if (state is InforFailure) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return Container();
          }
        });
    ;
  }

  Widget buildChoose() {
    return Column(
      children: [
        SettingItemWidget(
          leading: settingIconWidget(icon: Icons.abc),
          title: "Thay đổi thông tin",
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          onTap: () async {
            final res = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangeInforScreen()));
            if (res == true) {
              Future.delayed(const Duration(milliseconds: 2000), () {
                _bloc.refreshPage();
              }).then((value) => toastCreateComplete(""));
            }
          },
        ),
        SettingItemWidget(
          leading: settingIconWidget(icon: Icons.lock_outline),
          title: "Đổi mật khẩu",
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ChangePass()));
          },
        ),
        SettingItemWidget(
            leading: settingIconWidget(icon: Icons.logout),
            title: 'Đăng Xuất',
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Icon(CupertinoIcons.info_circle),
                        content: const Text(
                          'Bạn Muốn Đăng Xuất Khỏi Thiết Bị?',
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () => Navigator.pop(context),
                            child: Text("Huỷ", style: StyleApp.textStyle402()),
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () async {
                              await authService.logout();
                              Provider.of<AuthProvider>(context, listen: false)
                                  .setToken(null);
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child:
                                Text("Đồng ý", style: StyleApp.textStyle401()),
                          ),
                        ],
                      );
                    });
              });
            }),
      ],
    );
  }

  Widget buildChart(){
    return FutureBuilder<ChartMonthModel>(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ChartWithData(snapshot.data!);
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorAppStyle.button,
        automaticallyImplyLeading: false,
        title: const Text('Thông tin tài khoản'),
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
        child: Column(
          children: [
            buildInfor(),
            const SizedBox(
              height: 20,
            ),
            buildChoose(),
            buildChart()
            // Expanded(
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.vertical,
            //     child: Column(
            //       children: [
            //         SfCircularChart(
            //           title: ChartTitle(text: 'Month'),
            //           legend: Legend(
            //               isVisible: true, position: LegendPosition.bottom),
            //           tooltipBehavior: TooltipBehavior(enable: true),
            //           series: <CircularSeries<SalesData, String>>[
            //             PieSeries<SalesData, String>(
            //               enableTooltip: true,
            //               dataSource: <SalesData>[
            //                 SalesData('Jan', 30),
            //                 SalesData('Feb', 40),
            //                 SalesData('Mar', 50),
            //                 SalesData('Apr', 25),
            //                 SalesData('May', 60),
            //                 SalesData('Jun', 25),
            //                 SalesData('Jul', 25),
            //               ],
            //               xValueMapper: (SalesData sales, _) => sales.month,
            //               yValueMapper: (SalesData sales, _) => sales.sales,
            //               name: "Mood",
            //               explodeAll: true,
            //               explode: true,
            //               dataLabelSettings:
            //                   const DataLabelSettings(isVisible: true),
            //             ),
            //           ],
            //         ),
            //         SfCircularChart(
            //           title: ChartTitle(text: 'Month'),
            //           legend: Legend(
            //               isVisible: true, position: LegendPosition.bottom),
            //           tooltipBehavior: TooltipBehavior(enable: true),
            //           // primaryXAxis: CategoryAxis(),
            //           // primaryYAxis: NumericAxis(),
            //           series: <CircularSeries<SalesData, String>>[
            //             PieSeries<SalesData, String>(
            //               enableTooltip: true,
            //               dataSource: <SalesData>[
            //                 SalesData('Jan', 30),
            //                 SalesData('Feb', 40),
            //                 SalesData('Mar', 50),
            //                 SalesData('Apr', 25),
            //                 SalesData('May', 60),
            //                 SalesData('Jun', 25),
            //                 SalesData('Jul', 25),
            //               ],
            //               xValueMapper: (SalesData sales, _) => sales.month,
            //               yValueMapper: (SalesData sales, _) => sales.sales,
            //               name: "Mood",
            //               explodeAll: true,
            //               explode: true,
            //               dataLabelSettings:
            //                   const DataLabelSettings(isVisible: true),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}


class ChartWithData extends StatelessWidget {
  final ChartMonthModel data;

  const ChartWithData(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> formattedData = data.data
        .map((sales) => sales[1]?.toString() ?? "")
        .toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<String, String>>[
          LineSeries<String, String>(
            dataSource: formattedData,
          xValueMapper: (String sales, _) => sales,
          yValueMapper: (String sales, _) {
            return int.tryParse(sales) ?? 0;
          },
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}


