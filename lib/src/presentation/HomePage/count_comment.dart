import 'package:diary/src/bloc/get_comment_id/get_comment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class CountComment extends StatefulWidget {
  final int id;

  const CountComment({super.key, required this.id});

  @override
  State<CountComment> createState() => _CountCommentState();
}

class _CountCommentState extends State<CountComment> {
  late final GetCommentBloc _bloc;
  int? count;

  @override
  void initState() {
    super.initState();
    count = _bloc.list.length;
  }

  Widget buildCountComment() {
    return BlocBuilder<GetCommentBloc, GetCommentState>(
        bloc: _bloc..add(GetIdCMTDiary(id: widget.id)),
        builder: (context, state) {
          return state is GetCMTLoading
              ? const Center(child: CircularProgressIndicator())
              : (_bloc.list.isEmpty
                  ? const Center(
                      child: Text("No Comment"),
                    )
                  : SizedBox(height: 20,child: Text(_bloc.list.length.toString())));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Diary"),
      ),
      body: SafeArea(
          child: buildCountComment()),
    );
  }
}
