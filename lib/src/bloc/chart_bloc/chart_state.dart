part of 'chart_bloc.dart';

@immutable
abstract class ChartState {}

class ChartInitial extends ChartState {}

class ChartLoading extends ChartState {}

class ChartSuccess extends ChartState {}

class ChartFailure extends ChartState {
  final String error;
  ChartFailure(this.error);
}