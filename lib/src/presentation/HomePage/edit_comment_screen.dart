import 'package:diary/src/bloc/get_comment_id/get_comment_bloc.dart';
import 'package:diary/src/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class EditComment extends StatefulWidget {
  final int id;

  const EditComment({super.key, required this.id});

  @override
  State<EditComment> createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment> {
  TextEditingController editCmt = TextEditingController();
  late final GetCommentBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GetCommentBloc();
  }

  Widget buildCommentDiary() {
    return BlocBuilder<GetCommentBloc, GetCommentState>(
        bloc: _bloc..add(GetIdCMTDiary(id: widget.id)),
        builder: (context, state) {
          if (state is GetCMTLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetCMTSuccessV2) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Text(state.listAllDiary.id.validate().toString()),
              ],
            );
          } else if (state is GetCMTFailure) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return Container();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Comment"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              maxLines: null,
              controller: editCmt,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            buildCommentDiary(),
            ElevatedButton(onPressed: () {}, child: Text('Apply'))
          ],
        ),
      ),
    );
  }
}
