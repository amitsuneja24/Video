import 'package:flutter/material.dart';
Widget customButton({@required String title, onPressed,BuildContext context}) {
  return Container(
    margin: EdgeInsets.only(left: 70, right: 70, top: 15),
    child: RaisedButton(
      child: Text(title),
      onPressed: onPressed,
      color: Theme.of(context).buttonColor,
      textColor: Colors.white,
    ),
  );
}
