import 'package:diary/src/bloc/Search_bloc/search_bloc.dart';
import 'package:flutter/cupertino.dart';
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
        bloc: _bloc, builder: (context, state)  {
      if (state is SearchLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is SearchSuccess) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.album),
                  title:  Text(state.inforUser.nickName.validate()),
                  subtitle: Text(state.inforUser.date.validate()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('VIEW'),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        );
      }
      else if(state is SearchFailure){
        return Center(
          child: Text(state.error),
        );
      }
      else{
        return Container();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
   findByPhone = _bloc.findByPhone;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find by Phone'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: TextField(
                //maxLines: null,
                controller: findByPhone,
                maxLength: 10,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        _bloc.getSearch();
                      }, icon: const Icon(Icons.search)),
                  hintText: "Search",
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  //hintStyle: TextStyle(fontSize: 14)
                ),
              ),
            ).paddingSymmetric(horizontal: 10),
            buildSearch()
          ],
        ),
      ),
    );
  }
}
