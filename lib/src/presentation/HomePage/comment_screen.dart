import 'package:diary/src/bloc/editComment_bloc/edit_comment_bloc.dart';
import 'package:diary/src/bloc/get_comment_id/get_comment_bloc.dart';
import 'package:diary/src/presentation/HomePage/edit_comment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class CommentScreen extends StatefulWidget {
  final int id;

  const CommentScreen({
    super.key,
    required this.id,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController textComment = TextEditingController();
  TextEditingController editComment = TextEditingController();
  late final GetCommentBloc _bloc;
  late final EditCommentBloc _commentBloc;


  @override
  void initState() {
    super.initState();
    _commentBloc = EditCommentBloc(widget.id);
    _bloc = GetCommentBloc(widget.id);
    _bloc.getListComment(widget.id);
  }

  Widget buildTextComposer() {
    textComment = _bloc.commentController;
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
                  if (_bloc.commentController.text.isNotEmpty) {
                    _bloc.createComment();
                    _bloc.list.clear();
                    textComment.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCommentDiary() {
    return BlocBuilder<GetCommentBloc, GetCommentState>(
        bloc: _bloc,
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
                      itemBuilder: (context, index) {
                        return Column(
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
                                      if (_bloc.list[index].createdBy.validate() !=
                                     _commentBloc.model?.createdBy
                                          ) ...[
                                        SizedBox(
                                          width: 50,
                                          child: IconButton(
                                            icon: const Icon(Icons.edit_square),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditComment(
                                                            id: _bloc.list[index].id
                                                                .validate(),
                                                          )));
                                            },
                                          ),
                                        )
                                      ],

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
                            const Divider(
                              height: 1,
                              color: Colors.grey,
                              thickness: 1,
                              indent: 3,
                              endIndent: 3,
                            ),
                          ],
                        ).paddingLeft(10);
                      },
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
        actions: [
          IconButton(
              onPressed: () {
                _bloc.list.clear();
                _bloc.getListComment(widget.id);
              },
              icon: const Icon(Icons.refresh))
        ],
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
