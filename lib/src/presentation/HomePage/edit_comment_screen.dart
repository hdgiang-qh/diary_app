import 'package:diary/src/bloc/editComment_bloc/edit_comment_bloc.dart';
import 'package:diary/src/bloc/get_comment_id/get_comment_bloc.dart';
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
    _bloc = EditCommentBloc();
  }

  Widget buildCommentDiary() {
    return BlocBuilder<EditCommentBloc, EditCommentState>(
        bloc: _bloc..add(GetIdComment(id: widget.id)),
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
  Widget buildBtnSave(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(onPressed: (){
          deleteComment();
        }, child: const Text("Delete")),
        ElevatedButton(onPressed: () {
          editsComment();
        }, child: const Text('Apply')),
      ],
    );
  }
  Future<void> editsComment() async {
    final cmt = editCmt.text;
    try {
      Map<String, dynamic> data = {
        'comment': cmt,
        'diaryId': _bloc.model!.diaryId,
      };
      final res = await Api.putAsync(
        endPoint: "${ApiPath.comment}/${_bloc.model!.id}",
        req: data,
      );
      if (cmt.isEmpty) {
        return;
      } else if (res['status'] == "SUCCESS") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Post Success!'),
        ));
      } else {
        // Xử lý lỗi
        print('Fail: ${res.statusCode}');
        print(res.data);
        return;
      }
    } on DioException catch (e) {
      // Xử lý lỗi Dio
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Hãy điền đầy đủ thông tin'),
      ));
      print('Lỗi Dio: ${e.error}');
    } catch (e) {
      // Xử lý lỗi khác
      print('Lỗi: $e');
    }
  }
  Future<void> deleteComment() async {
    try {
      final res = await Api.deleteAsync(
        endPoint: "${ApiPath.comment}/${_bloc.model!.id}",
      );
      if (res['status'] == "SUCCESS") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Delete Success!'),
        ));
      } else {
        // Xử lý lỗi
        print('Fail: ${res.statusCode}');
        print(res.data);
        return;
      }
    } on DioException catch (e) {
      // Xử lý lỗi Dio
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        content: Text('You are not the owner of this comment'),
      ));
      print('Lỗi Dio: ${e.error}');
    } catch (e) {
      // Xử lý lỗi khác
      print('Lỗi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Comment"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildCommentDiary(),
            buildBtnSave()
          ],
        ),
      ),
    );
  }
}
