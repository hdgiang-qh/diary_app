import 'package:diary/src/bloc/editComment_bloc/edit_comment_bloc.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:diary/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
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

  void toastDeleteComplete(String messenger) => Fluttertoast.showToast(
      msg: "Delete Success",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white);

  void toastEditComplete(String messenger) => Fluttertoast.showToast(
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
                  style: const TextStyle(height: 1),
                  maxLines: null,
                  controller: editCmt,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 10);
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Icon(CupertinoIcons.info_circle),
                        content: const Text(
                          'Bạn Muốn Xoá Bình Luận Này?',
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () => Navigator.pop(context),
                            child: Text("Huỷ", style: StyleApp.textStyle402()),
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () {
                              _bloc.deleteComment();
                              toastDeleteComplete("");
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child:
                                Text("Đồng ý", style: StyleApp.textStyle401()),
                          ),
                        ],
                      );
                    });
              });
            },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorAppStyle.app8,
            side: const BorderSide(
                width: 2, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('Xoá bình luận',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),),
        ElevatedButton(
            onPressed: () {
              _bloc.editComment(_bloc.model!.diaryId);
              toastEditComplete("");
              Navigator.of(context).pop();
            },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorAppStyle.app8,
            side: const BorderSide(
                width: 2, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('Lưu chỉnh sửa',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorAppStyle.button,
        title: const Text("Chỉnh sửa bình luận"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorAppStyle.app5,
                ColorAppStyle.app6,
                ColorAppStyle.app2
              ],
            ),
            image: DecorationImage(
                image: AssetImage("assets/images/shape.png"),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            children: [
              buildCommentDiary().paddingSymmetric(vertical: 10),
              buildBtnSave()
            ],
          ),
        ),
      ),
    );
  }
}
