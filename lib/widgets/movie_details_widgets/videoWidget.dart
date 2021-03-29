import 'package:flutter/material.dart';
import 'package:ext_video_player/ext_video_player.dart';

import '../../networking/dataFetch.dart';

class VideoWidget extends StatefulWidget {
  VideoWidget({this.videoId});

  final String videoId; //the video's ID from the API

  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;
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
      _initializeVideo();
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

  _initializeVideo() {
    //play the video on full screen mode
    _controller = VideoPlayerController.network(
        'https://www.youtube.com/watch?v=$_youtubeVideoId')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  List<Widget> _videoWidget() {
    if (!_controller.value.isPlaying) {
      return [
        GestureDetector(
          //make the thumbnail clickable
          onTap: () {
            setState(() {
              _controller.play();
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            margin: EdgeInsets.only(right: 5.0, left: 10.0),
            height: 200.0,
            color: Colors.black,
            child: _thumbnail,
          ),
        ),
        Positioned(
          //a play button on top of the thumbnail
          left: MediaQuery.of(context).size.width / 2.4,
          child: FloatingActionButton(
            onPressed: null,
            backgroundColor: Colors.black26,
            child: Icon(Icons.play_arrow),
          ),
        )
      ];
    }

    return [
      GestureDetector(
        //make the thumbnail clickable
        onTap: () {
          setState(() {
            _controller.pause();
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          margin: EdgeInsets.only(right: 5.0, left: 10.0),
          height: 200.0,
          color: Colors.black,
          child: VideoPlayer(_controller),
        ),
      )
    ];
  }

  @override
  build(BuildContext context) {

    //check if the video was fetched
    if(_youtubeVideoId == null || !_controller.value.initialized) {
      return Container();
    }

    return Stack(
            //contains the thumbnail, and a play icon on top of it
            alignment: Alignment.center,
            children: _videoWidget());
  }
}
