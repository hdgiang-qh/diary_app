import 'package:diary/src/presentation/Auth/Infor/Information_screen.dart';
import 'package:diary/src/presentation/Diary/diary_screen.dart';
import 'package:diary/src/presentation/HomePage/home_screen.dart';
import 'package:diary/src/presentation/MessBot/messbot_screen.dart';
import 'package:diary/src/presentation/PodCast/podcast_screen.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../styles/text_styles.dart';
import 'bloc/state_bloc/state_nav_bloc.dart';

class DashBoard extends StatefulWidget {


  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  late final StateNavBloc _blocNav;
  var selectedIndex = 0;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                //<-- SEE HERE
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                // <-- SEE HERE
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  var pages = [
    const HomeScreen(),
    const PodCastScreen(),
    const MessBotScreen(),
    const DiaryScreen(),
    const Information(),
  ];

  @override
  void initState() {
    super.initState();
    _blocNav = StateNavBloc();
    _blocNav.tabcontroller = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _blocNav.tabcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocConsumer<StateNavBloc, StateNavState>(
        bloc: _blocNav,
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: TabBarView(
              controller: _blocNav.tabcontroller,
              physics: const NeverScrollableScrollPhysics(),
              children: pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: ColorAppStyle.button,
              onTap: _blocNav.onItemTapped,
              currentIndex: _blocNav.selectedIndex,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Trang Tin',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.podcasts), label: 'PodCast'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.forum), label: 'Chat Bot'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.edit_note), label: 'Nhật Ký'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.grid_view), label: 'Tuỳ Chọn'),
              ],
              selectedItemColor: Colors.white,
              selectedLabelStyle: boldTextStyle(size: 14),
              unselectedLabelStyle: boldTextStyle(size: 10),
              selectedFontSize: 12,
              unselectedFontSize: 12,
            ),
          );
        },
      ),
    );
  }
}
