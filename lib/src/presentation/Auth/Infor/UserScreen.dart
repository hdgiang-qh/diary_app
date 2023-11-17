import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late final InforBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = InforBloc();
    _bloc.getInfor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Information"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<InforBloc, InforState>(
            bloc: _bloc,
            builder: (context, state) {
              if (_bloc.inforUsers.isEmpty) {
                return const
                    //  CircularProgressIndicator();
                    Center(
                  child: Text("Loading Data..."),
                );
              }
              return state is InforLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Text(
                                  _bloc.inforUsers[index].nickName.validate()))
                        ],
                      ).paddingBottom(20),
                      // separatorBuilder: (context, index) => Container(),
                      itemCount: _bloc.inforUsers.length,
                      shrinkWrap: true,
                    );
            },
          ),
        ),
      ),
    );
  }
}
