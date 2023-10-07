part of 'state_nav_bloc.dart';

@immutable
abstract class StateNavState {}

class StateNavInitial extends StateNavState {}

class StateLoading extends StateNavState{}
class StateSuccess extends StateNavState{}