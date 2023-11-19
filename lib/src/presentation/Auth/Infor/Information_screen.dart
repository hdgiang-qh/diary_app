import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/service/provider_token.dart';
import 'package:diary/src/presentation/Auth/Infor/UserScreen.dart';
import 'package:diary/src/presentation/widget/common_widget.dart';
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
  final InforBloc _inforBloc = InforBloc()..add(GetInforUser());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        UserScreen(
          inforBloc: _inforBloc,
        ),
        SettingItemWidget(
            leading: settingIconWidget(icon: Icons.logout),
            title: 'Đăng Xuất',
            padding: const EdgeInsets.symmetric(
              vertical: 3,
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
                            child:
                            Text("Huỷ", style: StyleApp.textStyle402()),
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () async {
                              // await authService.logout();
                              //       Provider.of<AuthProvider>(context, listen: false).setToken(null);
                              //       Navigator.pop(context);
                            },
                            child: Text("Đồng ý",
                                style: StyleApp.textStyle401()),
                          ),
                        ],
                      );
                    });
              });
            }),
      ],
    ));
  }
}
