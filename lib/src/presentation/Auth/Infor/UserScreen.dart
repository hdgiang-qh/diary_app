import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({
    super.key,
    required InforBloc inforBloc,
  }) : _bloc = inforBloc;
  final InforBloc _bloc;

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
                      CircleAvatar(
                        radius: 60.0,
                        child:
                            Text(state.ifUser.nickName.removeAllWhiteSpace()),
                      ),
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
