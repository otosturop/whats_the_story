import 'package:flutter/material.dart';

enum ImageEnum { door, user, addUser, logo, signIn, google, search, profile }

extension ImageEnumExtension on ImageEnum {
  String get _toPath => 'assets/images/ic_$name.png';
  String get _toAvatar => 'assets/images/user_avatar/$name.png';

  Image get toImage => Image.asset(_toPath);
  Image get toAvatar => Image.asset(_toAvatar);
}
