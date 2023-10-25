import 'package:flutter_bloc/flutter_bloc.dart';

class BoolBloc extends Cubit<bool>{
BoolBloc() : super(false);
  void changeValue(bool value){
    emit(!state);
  }
}