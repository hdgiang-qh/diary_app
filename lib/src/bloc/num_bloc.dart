import 'package:flutter_bloc/flutter_bloc.dart';

class NumBloc extends Cubit<int>{
  NumBloc() : super(0);

 changeNum(int num){
   emit(num);
 }
}