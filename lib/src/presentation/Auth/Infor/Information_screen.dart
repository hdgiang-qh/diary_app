import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/service/provider_token.dart';
import 'package:diary/src/presentation/Auth/ChangePass/change_pass.dart';
import 'package:diary/src/presentation/Auth/Infor/Change_avatar.dart';
import 'package:diary/src/presentation/Auth/Infor/UserScreen.dart';
import 'package:diary/src/presentation/widget/common_widget.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:diary/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {

  Widget buildChoose() {
    return Column(
      children: [
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
            const UserScreen(),
            const SizedBox(
              height: 20,
            ),
            buildChoose()
          ],
        ),
      ),
    );
  }
}
