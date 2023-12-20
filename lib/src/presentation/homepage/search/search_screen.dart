import 'package:diary/src/bloc/Search_bloc/search_bloc.dart';
import 'package:diary/src/presentation/HomePage/Search/view_search.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController findByPhone = TextEditingController();
  late final SearchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc();
  }

  Widget buildSearch() {
    return BlocBuilder<SearchBloc, SearchState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SearchSuccess) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: ColorAppStyle.app5,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 2,
                    color: Colors.greenAccent,
                  ),
                  borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: Image(
                        image: NetworkImage(state.inforUser.avatar.validate()),
                      ),
                      title: Text(state.inforUser.nickName.validate()),
                      subtitleTextStyle: const TextStyle(fontSize: 12,fontWeight: FontWeight.w700),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ngày sinh: ${state.inforUser.date.validate()}"),
                          Text(
                              "Tuổi: ${state.inforUser.age.validate().toString()}")
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text(
                            'Xem thông tin',
                            style: TextStyle(color: ColorAppStyle.redFF),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewSearchScreen(
                                        createBy: _bloc.inforUser!.id)));
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (state is SearchFailure) {
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
    findByPhone = _bloc.findByPhone;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorAppStyle.button,
        title: const Text('Nhập số điện thoại'),
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 80,
                child: TextField(
                  //maxLines: null,
                  controller: findByPhone,
                  maxLength: 10,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          _bloc.getSearch();
                        },
                        icon: const Icon(Icons.search,color: Colors.white,)),
                    hintText: "Search",
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    // border: const OutlineInputBorder(
                    //     borderRadius: BorderRadius.all(Radius.circular(15))),
                    hintStyle: const TextStyle(color: Colors.white)
                  ),
                ),
              ).paddingSymmetric(horizontal: 10),
              buildSearch()
            ],
          ),
        ),
      ),
    );
  }
}
