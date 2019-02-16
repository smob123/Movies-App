import 'package:flutter/material.dart';

class About extends StatelessWidget {
  build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('About'),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
          child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
              child: Text(
                'This app was created using the TMDB API: https://developers.themoviedb.org/3/getting-started/authentication',
                style: Theme.of(context).textTheme.title,
              )),
        ),
      ),
    );
  }
}
