import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({
    super.key,
    required InforBloc inforBloc,
  }) : _bloc = inforBloc;
  final InforBloc _bloc;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InforBloc, InforState>(
        bloc: widget._bloc,
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
                  const SizedBox(height : 50),
                  const CircleAvatar(
                    radius: 30.0,
                    child: Text("G"),
                  ).paddingRight(5),
                  Text(state.ifUser.nickName.validate()),
                  Text(state.ifUser.phone.validate())
                ],
              ),
            );
          }
          else if(state is InforFailure){
            return Center(
              child: Text(state.error),
            );
          }
          else{
            return Container();
          }
        });
  }
}
