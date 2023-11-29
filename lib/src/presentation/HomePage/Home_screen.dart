import 'package:diary/src/bloc/auth_bloc/infor_bloc.dart';
import 'package:diary/src/bloc/getAlldiary_bloc/get_all_diary_bloc.dart';
import 'package:diary/src/presentation/HomePage/Search/Search_screen.dart';
import 'package:diary/src/presentation/HomePage/comment_screen.dart';
import 'package:diary/src/presentation/HomePage/separator_widget.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GetAllDiaryBloc _bloc;
  late final InforBloc _inforBloc;
  String? length;

  @override
  void initState() {
    super.initState();
    _bloc = GetAllDiaryBloc();
    _bloc.getAllDiary();
    _inforBloc = InforBloc();
    _inforBloc.getInforUser();
  }

  Widget buildListDiary() {
    return BlocBuilder<GetAllDiaryBloc, GetAllDiaryState>(
      bloc: _bloc,
      builder: (context, state) {
        return state is GetAllDiaryLoading
            ? const Center(child: CircularProgressIndicator())
            : (ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 5),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SeparatorWidget(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            backgroundColor: ColorAppStyle.getRandomColor(),
                            radius: 20.0,
                            child: Text(
                              _bloc.getAllDiaries[index].createdBy
                                  .validate()
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _bloc.getAllDiaries[index].nickname.validate(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "đang cảm thấy : ${_bloc.getAllDiaries[index].mood.validate()}",
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      letterSpacing: .5),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ).paddingOnly(top: 5, left: 10, bottom: 5),
                    SingleChildScrollView(
                      child: SizedBox(
                        child: Text(
                            _bloc.getAllDiaries[index].happened.validate(),
                            style: const TextStyle(fontSize: 15.0),
                            maxLines: null),
                      ),
                    ).paddingSymmetric(horizontal: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _bloc.getAllDiaries[index].createdAt.validate(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ).paddingOnly(right: 10, bottom: 3, top: 3),
                    const Divider(
                      height: 1,
                      color: Colors.grey,
                      thickness: 1,
                      indent: 8,
                      endIndent: 8,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.comment,
                            size: 18,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommentScreen(
                                            id: _bloc.getAllDiaries[index].id
                                                .validate(),
                                            idUser: _inforBloc.ifUser!.id
                                                .validate(),
                                          )));
                            },
                            child: const Row(
                              children: [
                                Text(
                                  "Comment",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SeparatorWidget()
                  ],
                ),
                separatorBuilder: (context, index) => Container(),
                itemCount: _bloc.getAllDiaries.length,
                shrinkWrap: true,
              ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false,
        title: const Text(
          "Diary For You",
        ),
        actions: [
          GestureDetector(
            child: const CircleAvatar(
              child: Text("A"),
            ).paddingRight(10),
            onTap: () {
              if (kDebugMode) {
                print('hello');
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 5, right: 5, bottom: 10),
                child: CupertinoSearchTextField(
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  enabled: true,
                  placeholder: 'Search',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchScreen()));
                  },
                ),
              ),
              buildListDiary(),
            ],
          ),
        ),
      ),
    );
  }
}
