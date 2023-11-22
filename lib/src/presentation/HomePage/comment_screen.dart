import 'package:diary/src/bloc/get_comment_id/get_comment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class CommentScreen extends StatefulWidget {
  final int id;

  const CommentScreen({super.key, required this.id});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}
class Count{
  int? count;
}
class _CommentScreenState extends State<CommentScreen> {
  late Count counts = Count();
  final TextEditingController _textController = TextEditingController();
  late final GetCommentBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GetCommentBloc();
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
                controller: _textController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                                    flex: 3,
                                    child: Text(
                                      " Feeling : ${_bloc.count}",
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
