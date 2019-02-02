import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

import '../../config/config.dart';
import '../../networking/dataFetch.dart';

class VideoWidget extends StatefulWidget {
  VideoWidget({this.videoId});

  final String videoId;

  VideoWidgetState createState() => VideoWidgetState(videoId: videoId);
}

class VideoWidgetState extends State<VideoWidget> {
  VideoWidgetState({this.videoId});

  final String videoId;
  String _youtubeVideoId;
  Image _thumbnail;

  @override
  void initState() {
    super.initState();
    _getVideoUrl();
  }

  Future _getVideoUrl() async {
    _youtubeVideoId = await DataFetch().getMovieTrailer(videoId);
    _getThumbnail();
  }

  _getThumbnail() {
    setState(() {
      _thumbnail = Image.network(
        'http://img.youtube.com/vi/$_youtubeVideoId/0.jpg',
        fit: BoxFit.fill,
      );
    });
  }

  _playVideo() {
    FlutterYoutube.playYoutubeVideoById(
        apiKey: apiData['youtube api key'],
        videoId: _youtubeVideoId,
        autoPlay: true,
        fullScreen: true);
  }

  @override
  build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      GestureDetector(
        onTap: () => _playVideo(),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          margin: EdgeInsets.only(right: 5.0, left: 10.0),
          height: 200.0,
          color: Colors.black,
          child: _thumbnail,
        ),
      ),
      Positioned(
        left: MediaQuery.of(context).size.width / 2.4,
        child: FloatingActionButton(
          onPressed: null,
          backgroundColor: Colors.black26,
          child: Icon(Icons.play_arrow),
        ),
      )
    ]);
  }
}
