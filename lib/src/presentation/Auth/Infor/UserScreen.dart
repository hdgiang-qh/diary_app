import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({
    super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late final InforBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = InforBloc();
    _bloc.getInforUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InforBloc, InforState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is InforLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is InforSuccess2) {
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
                              image: NetworkImage("${state.ifUser.avatar}")
                            )
                          ),
                          child: Container()),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name : ${state.ifUser.nickName.validate()}"),
                          Text("Phone : ${state.ifUser.phone.validate()}"),
                          Text(
                              "Age : ${state.ifUser.age.validate().toString()}"),
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
  }
}
