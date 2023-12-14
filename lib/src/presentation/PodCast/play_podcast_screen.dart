import 'package:diary/src/bloc/podcast_bloc/podcast_bloc.dart';
import 'package:diary/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nb_utils/nb_utils.dart';

class PlayPodCastScreen extends StatefulWidget {
  final int? id;
  final String? track, image, title, author;

  const PlayPodCastScreen(
      {super.key,
      required this.id,
      required this.track,
      required this.image,
      required this.title,
      required this.author});

  @override
  State<PlayPodCastScreen> createState() => _PlayPodCastScreenState();
}

class _PlayPodCastScreenState extends State<PlayPodCastScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final PodcastBloc _bloc;
  late AudioPlayer audioPlayer;
  double sliderValue = 5;
  bool showSlider = false;
  String thumbnailImgUrl =
      "https://ecdn.game4v.com/g4v-content/uploads/2022/10/09093327/Kimetsu-1-game4v-1665282804-5.png";
  var player = AudioPlayer();
  double volume = 5.0;
  bool loaded = false;
  bool playing = false;

  void loadMusic() async {
    await player.setUrl("${widget.track}");
    setState(() {
      loaded = true;
    });
  }

  void playMusic() async {
    setState(() {
      playing = true;
    });
    await player.play();
  }

  void pauseMusic() async {
    setState(() {
      playing = false;
    });
    await player.pause();
  }

  void increaseVolume() async {
    setState(() {
      playing = true;
      volume += 5;
      player.setVolume(volume);
    });
  }

  void decreaseVolume() async {
    setState(() {
      playing = true;
      volume -= 5;
      player.setVolume(volume);
    });
  }

  @override
  void initState() {
    loadMusic();
    _bloc = PodcastBloc();
    _bloc.getPodcastId(id: widget.id);
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
    player.setVolume(volume);
  }

  @override
  void dispose() {
    player.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorAppStyle.black7D,
        title: const Text("Music Player"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorAppStyle.purple6f,
              ColorAppStyle.purple8a,
              ColorAppStyle.blue75
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              "${widget.title}",
              style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ).paddingLeft(10),
            Text(
              "${widget.author}",
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    letterSpacing: .5),
              ),
            ).paddingLeft(10),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: RotationTransition(
                  turns: _controller,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('${widget.image}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ).paddingBottom(10),
            ).paddingBottom(30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: StreamBuilder(
                  stream: player.positionStream,
                  builder: (context, snapshot1) {
                    final Duration duration = loaded
                        ? snapshot1.data as Duration
                        : const Duration(seconds: 0);
                    return StreamBuilder(
                        stream: player.bufferedPositionStream,
                        builder: (context, snapshot2) {
                          final Duration bufferedDuration = loaded
                              ? snapshot2.data as Duration
                              : const Duration(seconds: 0);
                          return SizedBox(
                            height: 30,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ProgressBar(
                                progress: duration,
                                total: player.duration ??
                                    const Duration(seconds: 0),
                                buffered: bufferedDuration,
                                timeLabelPadding: -1,
                                timeLabelTextStyle: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                                progressBarColor: Colors.red,
                                baseBarColor: Colors.grey[200],
                                bufferedBarColor: Colors.grey[350],
                                thumbColor: Colors.red,
                                onSeek: loaded
                                    ? (duration) async {
                                        await player.seek(duration);
                                      }
                                    : null,
                              ),
                            ),
                          );
                        });
                  }),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  width: 30,
                ),
                IconButton(
                    onPressed: loaded
                        ? () async {
                            if (player.position.inSeconds >= 10) {
                              await player.seek(Duration(
                                  seconds: player.position.inSeconds - 10));
                            } else {
                              await player.seek(const Duration(seconds: 0));
                            }
                          }
                        : null,
                    icon: const Icon(
                      Icons.fast_rewind_rounded,
                      color: Colors.red,
                    )),
                Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
                  child: IconButton(
                      onPressed: loaded
                          ? () {
                              if (playing) {
                                pauseMusic();
                              } else {
                                playMusic();
                              }
                            }
                          : null,
                      icon: Icon(
                        playing ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      )),
                ),
                IconButton(
                    onPressed: loaded
                        ? () async {
                            if (player.position.inSeconds + 10 <=
                                player.duration!.inSeconds) {
                              await player.seek(Duration(
                                  seconds: player.position.inSeconds + 10));
                            } else {
                              await player.seek(const Duration(seconds: 0));
                            }
                          }
                        : null,
                    icon: const Icon(
                      Icons.fast_forward_rounded,
                      color: Colors.red,
                    )),
                SizedBox(
                  width: 30,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        showSlider = !showSlider;
                      });
                    },
                    icon: const Icon(
                      Icons.volume_up_outlined,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showSlider)
                  Slider(
                    activeColor: Colors.red,
                    inactiveColor: Colors.blue,
                    thumbColor: Colors.red,
                    value: sliderValue,
                    onChanged: (value) {
                      setState(() {
                        sliderValue = value;
                        player.setVolume(value);
                      });
                    },
                    label: '$sliderValue',
                    // Hiển thị giá trị trên Slider
                    min: 0,
                    max: 100,
                    divisions: 100,
                  ),
              ],
            ),
            const Spacer(
              flex: 2,
            )
          ],
        ),
      ),
    );
  }
}
