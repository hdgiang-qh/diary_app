part of 'podcast_bloc.dart';

@immutable
abstract class PodcastState {}

class PodcastInitial extends PodcastState {}

class PodcastLoading extends PodcastState{}

class PodcastSuccess extends PodcastState{
  final List<PodcastModel> listPod;
  PodcastSuccess(this.listPod);
}

class PodcastSuccessV2 extends PodcastState{
  final PodcastModel model;
  PodcastSuccessV2(this.model);
}

class PodcastFailure extends PodcastState{
  final String error;
  PodcastFailure({required this.error});
}