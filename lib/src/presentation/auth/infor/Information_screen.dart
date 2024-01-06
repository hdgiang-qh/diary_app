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
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class Month {
  int index;
  final String name;

  Month(this.index, this.name);
}

class _InformationState extends State<Information> {
  late final InforBloc _bloc;
  late final ChartBloc _chartBloc;
  int? id;
  List<Month> months = [
    Month(1, "Tháng 1"),
    Month(2, "Tháng 2"),
    Month(3, "Tháng 3"),
    Month(4, "Tháng 4"),
    Month(5, "Tháng 5"),
    Month(6, "Tháng 6"),
    Month(7, "Tháng 7"),
    Month(8, "Tháng 8"),
    Month(9, "Tháng 9"),
    Month(10, "Tháng 10"),
    Month(11, "Tháng 11"),
    Month(12, "Tháng 12"),
  ];

  Month? selectMonth;

  @override
  void initState() {
    _chartBloc = ChartBloc();
    _chartBloc.getDataChart();
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

  Widget buildDropDown() {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 5),
      color: Colors.white,
      child: DropdownButton<Month>(
        underline: Container(),
        hint: const Text('Chọn'),
        value: selectMonth,
        onChanged: (Month? newValue) {
          setState(() {
            selectMonth = newValue;
            id = months.indexOf(newValue!) + 1;
            _chartBloc.list.clear();
            _chartBloc.getDataChart(id: id);
          });
        },
        items: months.map((Month month) {
          return DropdownMenuItem<Month>(
            value: month,
            child: Text(month.name),
          );
        }).toList(),
      ),
    );
  }

  Widget buildChart() {
    String formattedDate = DateFormat.M().format(DateTime.now());
    return BlocBuilder<ChartBloc, ChartState>(
      bloc: _chartBloc,
      builder: (context, state) {
        return SfCartesianChart(
          title: ChartTitle(
              alignment: ChartAlignment.near,
              text: 'Thống kê cảm xúc tháng ${id ?? formattedDate}',
              textStyle: const TextStyle(fontSize: 12)),
          legend: Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            interval: 0.5,
            numberFormat: NumberFormat.decimalPattern(),
          ),
          series: <ColumnSeries<ChartMonthModelV2, String>>[
            ColumnSeries<ChartMonthModelV2, String>(
              enableTooltip: true,
              dataSource: _chartBloc.list,
              xValueMapper: (ChartMonthModelV2 sales, _) => sales.mood,
              yValueMapper: (ChartMonthModelV2 sales, _) => sales.count,
              name: _chartBloc.list.isEmpty ? "Không có dữ liệu" : "Cảm xúc",
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    flex: 3,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: const Text("Chọn Tháng:").paddingRight(5))),
                Expanded(flex: 1, child: buildDropDown()),
              ],
            ).paddingSymmetric(horizontal: 5),
            Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, child: buildChart()),
            ),
          ],
        ),
      ),
    );
  }
}
