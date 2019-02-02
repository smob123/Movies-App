import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget({this.color});
  final Color color;

  @override
  build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ));
  }
}
