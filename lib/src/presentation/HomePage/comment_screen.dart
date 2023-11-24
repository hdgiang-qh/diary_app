import 'package:diary/src/bloc/editComment_bloc/edit_comment_bloc.dart';
import 'package:diary/src/bloc/get_comment_id/get_comment_bloc.dart';
import 'package:diary/src/core/api.dart';
import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/presentation/HomePage/edit_comment_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class CommentScreen extends StatefulWidget {
  final int id;

  const CommentScreen({super.key, required this.id});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController textComment = TextEditingController();
  TextEditingController editComment = TextEditingController();
  late final GetCommentBloc _bloc;
  late final EditCommentBloc _commentBloc;
  int? idCount;

  @override
  void initState() {
    super.initState();
    _bloc = GetCommentBloc();
    _commentBloc = EditCommentBloc();
  }

  Widget buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: textComment,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a comment',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  createComment();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createComment() async {
    final cmt = textComment.text;
    try {
      Map<String, dynamic> data = {
        'comment': cmt,
        'diaryId': _bloc.id,
      };
      final res = await Api.postAsync(
        endPoint: ApiPath.comment,
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



  Future<void> openEdit() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Edit lor"),
            content: TextField(
              controller: editComment,
              decoration: const InputDecoration(),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'))
            ],
          ));




  Widget buildCommentDiary() {
    return BlocBuilder<GetCommentBloc, GetCommentState>(
        bloc: _bloc..add(GetIdCMTDiary(id: widget.id)),
        builder: (context, state) {
          return state is GetCMTLoading
              ? const Center(child: CircularProgressIndicator())
              : (_bloc.list.isEmpty
                  ? const Center(
                      child: Text("No Comment"),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 20.0,
                                          child: Text("G"),
                                        ).paddingRight(5),
                                        Text(
                                          _bloc.list[index].nickName
                                              .validate()
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_square),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditComment(
                                                          id: _bloc
                                                              .list[index].id
                                                              .validate(),
                                                        )));
                                          },
                                        ),

                                      ],
                                    ),
                                  )
                                ],
                              ).paddingTop(5),
                              SingleChildScrollView(
                                child: SizedBox(
                                  child: Text(
                                      _bloc.list[index].comment.validate(),
                                      style: const TextStyle(fontSize: 15.0),
                                      maxLines: null),
                                ),
                              ),
                            ],
                          ).paddingLeft(10),
                          const Divider(
                            height: 1,
                            color: Colors.grey,
                            thickness: 1,
                            indent: 8,
                            endIndent: 8,
                          ),
                        ],
                      ),
                      separatorBuilder: (context, index) => Container(),
                      itemCount: _bloc.list.length,
                      shrinkWrap: true,
                    ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Diary"),
      ),
      body: Column(
        children: [
          SingleChildScrollView(child: buildCommentDiary()),
          buildTextComposer()
        ],
      ),
    );
  }
}
