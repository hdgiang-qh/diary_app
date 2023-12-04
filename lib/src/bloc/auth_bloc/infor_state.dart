part of 'infor_bloc.dart';

@immutable
abstract class InforState {}

class InforInitial extends InforState {}

class InforSuccess extends InforState{
  final List<InforUserRole> inforUserRole;
  InforSuccess(this.inforUserRole);
}
class InforSuccess2 extends InforState{
  final InforUser ifUser;
  InforSuccess2(this.ifUser);
}

class InforSuccess3 extends InforState{
  final InforUser ifUser1;
  InforSuccess3(this.ifUser1);
}

class InforLoading extends InforState{}

class InforFailure extends InforState{
  final String error;
  InforFailure({required this.error});
}
