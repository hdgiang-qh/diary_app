import 'package:diary/src/bloc/mood_bloc/mood_bloc.dart';
import 'package:diary/src/bloc/podcast_bloc/podcast_bloc.dart';
import 'package:diary/src/presentation/PodCast/play_podcast_screen.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
@override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
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
                        selectedColor: Colors.cyan,
                        labelStyle: const TextStyle(
                          fontSize: 12,
                        ),
                        label: Text(
                            _moodBloc.moodMusics[index].moodSound.validate()),
                        selected: _value == index,
                        onSelected: (bool selected) {
                          setState(() {
                            _value = selected ? index : null;
                            if (_value == index) {
                              ind = _value! + 1;
                            } else if (_value == null) {
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
          return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SmartRefresher(
                  controller: _bloc.refreshController,
                  onRefresh: (){
                    _bloc.getListPodcast(isRefresh: true);
                    EasyLoading.dismiss();
                  },
                  child: GridView.builder(
                      primary: false,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      shrinkWrap: true,
                      itemCount: _bloc.podcast.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: NetworkImage(
                                    '${_bloc.podcast[index].poster}'),
                                fit: BoxFit.cover),
                          ),
                          child: ListTile(
                            title: Text(
                              _bloc.podcast[index].title.validate(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                            subtitle: Text(_bloc.podcast[index].author.validate(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ).onTap(() {
                          PlayPodCastScreen(
                            id: _bloc.podcast[index].id.validate(),
                            track: _bloc.podcast[index].track.validate().toString(),
                            image:
                                _bloc.podcast[index].poster.validate().toString(),
                            title: _bloc.podcast[index].title.validate(),
                            author: _bloc.podcast[index].author.validate(),
                          ).launch(context);
                        });
                      },
                    ),
                ),
              );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorAppStyle.button,
        automaticallyImplyLeading: false,
        title: const Text('PodCast'),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorAppStyle.app5,
                ColorAppStyle.app6,
                ColorAppStyle.app2
              ],
            ),
            image: DecorationImage(
                image: AssetImage("assets/images/shape.png"),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            children: [
              buildMoodMusic(),
              Expanded(child: buildListPod()),
            ],
          ),
        ),
      ),
    );
  }
}
