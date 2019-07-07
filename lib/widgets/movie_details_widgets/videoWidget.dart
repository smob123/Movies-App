import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

import '../../config/config.dart';
import '../../networking/dataFetch.dart';

class VideoWidget extends StatefulWidget {
  VideoWidget({this.videoId});

  final String videoId; //the video's ID from the API

  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  String _youtubeVideoId; //the actual video's ID on YouTube
  Image _thumbnail; //the video's thumbnail

  @override
  void initState() {
    super.initState();
    _getVideoUrl();
  }

  Future _getVideoUrl() async {
    //get the video's ID from YouTube
    _youtubeVideoId = await DataFetch().getMovieTrailer(widget.videoId);
    //make sure it's not null, then get the video's thumbnail
    if (_youtubeVideoId != null) {
      _getThumbnail();
    }
  }

  _getThumbnail() {
    setState(() {
      //gets the video's thumbnail from YouTube's image API
      _thumbnail = Image.network(
        'http://img.youtube.com/vi/$_youtubeVideoId/0.jpg',
        fit: BoxFit.fill,
      );
    });
  }

  _playVideo() {
    //play the video on full screen mode
    FlutterYoutube.playYoutubeVideoById(
        apiKey: apiData['youtube api key'],
        videoId: _youtubeVideoId,
        autoPlay: true,
        fullScreen: true);
  }

  @override
  build(BuildContext context) {
    return _youtubeVideoId == null //check if the video was fetched
        ? Container()
        : Stack( //contains the thumbnail, and a play icon on top of it
        alignment: Alignment.center, children: [
            GestureDetector( //make the thumbnail clickable
              onTap: () => _playVideo(), //play the video on tap
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                margin: EdgeInsets.only(right: 5.0, left: 10.0),
                height: 200.0,
                color: Colors.black,
                child: _thumbnail,
              ),
            ),
            Positioned( //a play button on top of the thumbnail
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
