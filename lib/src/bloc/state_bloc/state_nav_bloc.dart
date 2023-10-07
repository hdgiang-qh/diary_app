

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'state_nav_event.dart';
part 'state_nav_state.dart';

class StateNavBloc extends Bloc<StateNavEvent, StateNavState> {
  StateNavBloc() : super(StateNavInitial()) ;

  late TabController tabcontroller;

  var selectedIndex = 0;

  void onItemTapped(int index) {
    emit(StateLoading());
    selectedIndex = index;

    tabcontroller.animateTo(index, curve: Curves.linearToEaseOut);
    emit(StateSuccess());
  }
}
