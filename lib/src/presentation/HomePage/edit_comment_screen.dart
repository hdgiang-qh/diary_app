import 'package:diary/src/bloc/editComment_bloc/edit_comment_bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:dio/dio.dart';
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
  late final EditCommentBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = EditCommentBloc(widget.id);
    _bloc.getComment(widget.id);
  }
  void toastDeleteComplate(String messenger) => Fluttertoast.showToast(
      msg: "Delete Success",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  void toastEditComplate(String messenger) => Fluttertoast.showToast(
      msg: "Edit Success",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  Widget buildCommentDiary() {
    _bloc.editCommentController = editCmt;
    return BlocBuilder<EditCommentBloc, EditCommentState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is EditCommentLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is EditCommentSuccess) {
            editCmt.text = state.cmtM.comment.validate().toString();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  maxLines: null,
                  controller: editCmt,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            );
          } else if (state is EditCommentFailure) {
            return Center(
              child: Text(state.er.toString()),
            );
          } else {
            return Container();
          }
        });
  }

  Widget buildBtnSave() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () {
              _bloc.deleteComment();
              toastDeleteComplate("");
              Navigator.pop(context);
            },
            child: const Text("Delete")),
        ElevatedButton(
            onPressed: () {
              _bloc.editComment(_bloc.model!.diaryId);
              toastEditComplate("");
              Navigator.pop(context);
            },
            child: const Text('Apply')),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Comment"),
      ),
      body: SafeArea(
        child: Column(
          children: [buildCommentDiary(), buildBtnSave()],
        ),
      ),
    );
  }
}
