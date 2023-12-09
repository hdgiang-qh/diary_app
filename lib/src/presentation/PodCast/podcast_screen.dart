import 'package:diary/src/bloc/mood_bloc/mood_bloc.dart';
import 'package:diary/src/bloc/podcast_bloc/podcast_bloc.dart';
import 'package:diary/src/presentation/PodCast/play_podcast_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class PodCastScreen extends StatefulWidget {
  const PodCastScreen({super.key});

  @override
  State<PodCastScreen> createState() => _PodCastScreenState();
}

class _PodCastScreenState extends State<PodCastScreen>
    with SingleTickerProviderStateMixin {
  late final PodcastBloc _bloc;
  late final MoodBloc _moodBloc;
  late final AnimationController controller;
  int? _value;
  int? ind;


  @override
  void initState() {
    super.initState();
    _bloc = PodcastBloc();
    _bloc.getListPodcast();
    _moodBloc = MoodBloc();
    _moodBloc.getMoodMusic();
  }

  Widget buildMoodMusic() {
    return BlocBuilder<MoodBloc, MoodState>(
        bloc: _moodBloc,
        builder: (context, state) {
          return state is MoodLoading
              ? Container()
              : Wrap(
                  spacing: 5.0,
                  children: List.generate(
                    _moodBloc.moodMusics.length,
                    (int index) {
                      return ChoiceChip(
                        labelStyle: const TextStyle(fontSize: 10),
                        label: Text(
                            _moodBloc.moodMusics[index].moodSound.validate()),
                        selected: _value == index,
                        onSelected: (bool selected) {
                          setState(() {
                            _value = selected ? index : null;
                            if(_value == index){
                              ind = _value! + 1;
                            }
                            else if(_value == null){
                              ind = null;
                            }
                            _bloc.id = ind;
                            _bloc.podcast.clear();
                            _bloc.getListPodcast();
                          });
                        },
                      );
                    },
                  ).toList(),
                );
        });
  }

  Widget buildListPod() {
    return BlocBuilder<PodcastBloc, PodcastState>(
        bloc: _bloc,
        builder: (context, state) {
          return state is PodcastLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _bloc.podcast.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Image(
                              height: 30,
                              width: 50,
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                  '${_bloc.podcast[index].poster}'),
                            ),
                            title: Text(_bloc.podcast[index].title.validate()),
                            subtitle:
                                Text(_bloc.podcast[index].author.validate()),
                          ),
                        ).onTap(() {
                          PlayPodCastScreen(
                            id: _bloc.podcast[index].id.validate(),
                            track: _bloc.podcast[index].track
                                .validate()
                                .toString(),
                            image: _bloc.podcast[index].poster
                                .validate()
                                .toString(),
                            title: _bloc.podcast[index].title.validate(),
                            author: _bloc.podcast[index].author.validate(),
                          ).launch(context);
                        });
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(thickness: 2);
                      },
                    ),
                  ],
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('PodCast'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildMoodMusic(),
              buildListPod(),
            ],
          ),
        ),
      ),
    );
  }
}
