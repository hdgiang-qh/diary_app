part of 'chart_bloc.dart';

@immutable
abstract class ChartState {}

class ChartInitial extends ChartState {}

class ChartLoading extends ChartState {}

class ChartSuccessV1 extends ChartState {
  final ChartMonthModelV2 modelMonth;
  ChartSuccessV1(this.modelMonth);
}

class ChartSuccess extends ChartState {
  final List<ChartMonthModelV2> modelM;
  ChartSuccess(this.modelM);
}

class ChartFailure extends ChartState {
  final String error;
  ChartFailure(this.error);
}