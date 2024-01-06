part of 'chart_bloc.dart';

@immutable
abstract class ChartState {}

class ChartInitial extends ChartState {}

class ChartLoading extends ChartState {}

class ChartSuccessV1 extends ChartState {
  final ChartModelV2 modelChart;
  ChartSuccessV1(this.modelChart);
}

class ChartSuccessV2 extends ChartState {
  final ChartModel modelChart;
  ChartSuccessV2(this.modelChart);
}

class ChartSuccess extends ChartState {
  final List<ChartModelV2> modelM;
  ChartSuccess(this.modelM);
}

class ChartFailure extends ChartState {
  final String error;
  ChartFailure(this.error);
}