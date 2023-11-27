import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController findByPhone = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                      onPressed: () {}, icon: const Icon(Icons.search)),
                  hintText: "Search",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  //hintStyle: TextStyle(fontSize: 14)
                ),
              ),
            ).paddingSymmetric(horizontal: 10),
          ],
        ),
      ),
    );
  }
}
