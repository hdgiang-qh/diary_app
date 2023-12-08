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
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    _bloc = PodcastBloc();
    _bloc.getListPodcast();
  }

  Widget buildListPod() {
    return BlocBuilder<PodcastBloc, PodcastState>(
        bloc: _bloc,
        builder: (context, state) {
          return state is PodcastLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _bloc.podcast.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Image(
                          height: 30,
                          fit: BoxFit.contain,
                          image: NetworkImage('${_bloc.podcast[index].poster}'),
                        ),
                        title: Text(_bloc.podcast[index].title.validate()),
                        subtitle: Text(_bloc.podcast[index].author.validate()),
                      ),
                    ).onTap(() {
                      PlayPodCastScreen(
                        id: _bloc.podcast[index].id.validate(),
                        track: _bloc.podcast[index].track.validate().toString(),
                      ).launch(context);
                    });
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(thickness: 2);
                  },
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
          child: buildListPod(),
        ),
      ),
    );
  }
}
