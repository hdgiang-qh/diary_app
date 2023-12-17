part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState{}

class SearchSuccess extends SearchState{
  final InforUser inforUser;
  SearchSuccess(this.inforUser);
}

class SearchFailure extends SearchState{
  String error = 'Error Value';
  SearchFailure({required this.error});
}
