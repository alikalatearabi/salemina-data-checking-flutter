import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salemina_data/shared/popup.dart';

Future<void> uploadMainImageApi(BuildContext context, File imageFile) async {
  _showLoadingDialog(context);
  String url = 'http://194.147.222.179:3005/api/product/image/main';

  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();

  Navigator.of(context).pop();

  if (response.statusCode == 200) {
    popUp(context, ".عکس با موفقیت آپلود گردید");
  } else {
    _showPopup(context, "خطا در آپلود عکس");
  }
}

Future<void> uploadInfoImageApi(BuildContext context, File imageFile) async {
  _showLoadingDialog(context);
  String url = 'http://194.147.222.179:3005/api/product/image';

  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();

  Navigator.of(context).pop();

  if (response.statusCode == 200) {
    popUp(context, ".عکس با موفقیت آپلود گردید");
  } else {
    _showPopup(context, "خطا در آپلود عکس");
  }
}

Future<void> uploadExtraImageApi(BuildContext context, File imageFile) async {
  _showLoadingDialog(context);

  String url = 'http://194.147.222.179:3005/api/product/image/extra';

  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    Navigator.of(context).pop();
    popUp(context, 'عکس با موفقیت اضافه شد');
  } else {
    print('Image upload failed with status: ${response.statusCode}');
    return;
  }
}

void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
}

void _showPopup(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
