part of 'infor_bloc.dart';

@immutable
abstract class InforState {}

class InforInitial extends InforState {}

class InforSuccess extends InforState{
  final List<InforUser> inforUser;
  InforSuccess(this.inforUser);
}
class InforSuccess2 extends InforState{
  final InforUser ifUser;
  InforSuccess2(this.ifUser);
}

class InforLoading extends InforState{}

class InforFailure extends InforState{
  final String error;
  InforFailure({required this.error});
}
