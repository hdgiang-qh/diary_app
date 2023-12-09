import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:diary/src/bloc/get_comment_id/get_comment_bloc.dart';
import 'package:diary/src/presentation/HomePage/edit_comment_screen.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class CommentScreen extends StatefulWidget {
  final int id, idUser;

  const CommentScreen({super.key, required this.id, required this.idUser});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController textComment = TextEditingController();
  TextEditingController editComment = TextEditingController();
  late final GetCommentBloc _bloc;
  late final InforBloc _inforBloc;

  @override
  void initState() {
    super.initState();
    _inforBloc = InforBloc();
    _inforBloc.getInforUser();
    _bloc = GetCommentBloc(widget.id);
    _bloc.getListComment(widget.id);
  }

  Widget buildTextComposer() {
    textComment = _bloc.commentController;
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: textComment,
                decoration:
                    const InputDecoration.collapsed(hintText: 'Nhập...'),
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
        ).paddingLeft(5),
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
                      child: Text("Chưa có bình luận"),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                topRight: Radius.circular(12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(_bloc
                                                    .list[index].avatar
                                                    .validate()
                                                    .toString())),
                                          ),
                                          child: Container(),
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
                                        if (_bloc.list[index].createdBy
                                                .validate()
                                                .toString() ==
                                            widget.idUser.toString()) ...[
                                          SizedBox(
                                            width: 50,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.edit_square,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditComment(
                                                              id: _bloc
                                                                  .list[index]
                                                                  .id
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
                            ],
                          ).paddingLeft(10),
                        ).paddingSymmetric(horizontal: 10, vertical: 5);
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
        backgroundColor: Colors.purpleAccent,
        title: const Text("Bình luận bài viết"),
        actions: [
          IconButton(
              onPressed: () {
                _bloc.list.clear();
                _bloc.getListComment(widget.id);
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorAppStyle.purple6f,
                ColorAppStyle.purple8a,
                ColorAppStyle.blue75
              ],
            ),
            image: DecorationImage(
                image: AssetImage("assets/images/shape.png"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(child: buildCommentDiary()).paddingBottom(5),
              buildTextComposer()
            ],
          ),
        ),
      ),
    );
  }
}
