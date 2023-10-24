import 'package:diary/src/widget_screen/Diary/diary_screen.dart';
import 'package:diary/src/widget_screen/HomePage/Home_screen.dart';
import 'package:diary/src/widget_screen/MessBot/messbot_screen.dart';
import 'package:diary/src/widget_screen/PodCast/podcast_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../styles/color_styles.dart';
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

  var pages = [
    const HomeScreen(),
    const PodCastScreen(),
    const MessBotScreen(),
    const DiaryScreen(),
    const DiaryScreen(),
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
    return BlocConsumer<StateNavBloc, StateNavState>(
      bloc: _blocNav,
      listener: (context, state) {
      },
      builder: (context, state) {
        return Scaffold(
          body: TabBarView(
            controller: _blocNav.tabcontroller,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            onTap: _blocNav.onItemTapped,
            currentIndex: _blocNav.selectedIndex,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label : 'Home',
              ),
              BottomNavigationBarItem(
                  icon:  Icon(Icons.podcasts),
                  label : 'PodCast'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.forum),
                  label : 'MessBot'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.edit_note),
                  label : 'Diary'
              ),
              BottomNavigationBarItem(
                  icon:  Icon(Icons.grid_view),
                  label : 'Category'
              ),
            ],
            selectedItemColor: primaryColor,
            selectedLabelStyle: boldTextStyle(size: 14),
            unselectedLabelStyle: boldTextStyle(size: 10),
            selectedFontSize: 12,
            unselectedFontSize: 12,
          ),
        );
      },
    );
  }
}

