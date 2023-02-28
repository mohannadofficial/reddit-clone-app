import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
}

enum RequestState {
  loading,
  loaded,
  error,
  none,
}

enum UserKarma {
  comment(1),
  typeText(2),
  typeImg(3),
  typeLink(3),
  award(5),
  deletePost(-1);

  final int karma;
  const UserKarma(this.karma);
}

enum ThemeModes {
  light,
  dark,
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);
  return image;
}
