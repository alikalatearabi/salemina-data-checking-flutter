import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salemina_data/shared/popup.dart';
import 'package:salemina_data/shared/styled_banner.dart';

Future<void> uploadMainImageApi(
    BuildContext context, File imageFile, Function loadingDialog) async {
  loadingDialog(context);
  String url = 'http://194.147.222.179:3005/api/product/image/main';

  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    Navigator.of(context).pop();
    popUp(context, ".عکس با موفقیت آپلود گردید");
  } else {
    return;
  }
}

Future<void> uploadInfoImageApi(
    BuildContext context, File imageFile, Function loadingDialog) async {
  loadingDialog(context);

  String url = 'http://194.147.222.179:3005/api/product/image';

  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    Navigator.of(context).pop();
    popUp(context, ".عکس با موفقیت آپلود گردید");
  } else {
    return;
  }
}

Future<void> uploadExtraImageApi(
    BuildContext context, File imageFile, Function loadingDialog) async {
  loadingDialog(context);

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

Future<void> submitNewProduct(
  BuildContext context,
  String barcode,
  File? infoImage,
  File? mainImage,
  File? extraImage,
  String userName,
  TextEditingController calorieExt,
  TextEditingController totalFat,
  TextEditingController saturatedFat,
  TextEditingController unsaturatedFat,
  TextEditingController transFat,
  TextEditingController protein,
  TextEditingController carbohydrate,
  TextEditingController sugarExt,
  TextEditingController saltExt,
  TextEditingController cholesterol,
  TextEditingController sodium,
  TextEditingController name,
  TextEditingController brand,
  TextEditingController per,
  TextEditingController calorie,
  TextEditingController sugar,
  TextEditingController fat,
  TextEditingController salt,
  TextEditingController transFattyAcids,
  TextEditingController fiber,
  TextEditingController calFat,
) async {
  if (infoImage == null || mainImage == null) {
    styledBanner(context, 'عکس محصول اجباری می باشد');
  } else {
    final url = Uri.parse('http://194.147.222.179:3005/api/product');

    String productExtraCode = '';

    if (calorieExt.text != '' ||
        totalFat.text != '' ||
        saturatedFat.text != '' ||
        unsaturatedFat.text != '' ||
        transFattyAcids.text != '' ||
        protein.text != '' ||
        carbohydrate.text != '' ||
        sugarExt.text != '' ||
        saltExt.text != '' ||
        fiber.text != '' ||
        sodium.text != '' ||
        cholesterol.text != '') {
      productExtraCode = '7';
    }

    final Map<String, dynamic> productData = {
      'child_cluster': '',
      'product_name': name.text,
      'brand': brand.text,
      'barcode': barcode,
      'picture_old': '',
      'product_description': '',
      'per': per.text,
      'calorie': calorie.text,
      'sugar': sugar.text,
      'fat': fat.text,
      'salt': salt.text,
      'trans_fatty_acids': transFattyAcids.text,
      "Main_data_status": "7",
      "Extra_data_status": productExtraCode,
      "importer": userName,
      "monitor": "",
      "cluster": '',
      "picture_new": infoImage.path.split('/').last,
      "picture_main_info": mainImage.path.split('/').last,
      "picture_extra_info":
          extraImage != null ? extraImage.path.split('/').last : '',
      "per_ext": '',
      "calorie_ext": calorieExt.text,
      "cal_fat": calFat.text,
      "total_fat": totalFat.text,
      "saturated_fat": saturatedFat.text,
      "unsaturated_fat": unsaturatedFat.text,
      "trans_fat": transFat.text,
      "protein": protein.text,
      "sugar_ext": sugarExt.text,
      "carbohydrate": carbohydrate.text,
      "fiber": fiber.text,
      "salt_ext": saltExt.text,
      "sodium": sodium.text,
      "cholesterol": cholesterol.text
    };

    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    try {
      final request = await httpClient.postUrl(url);
      request.headers.set('Content-Type', 'application/json');
      request.add(utf8.encode(jsonEncode(productData)));
      final response = await request.close();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "محصول با موفقیت اضافه شد",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        final responseBody = await response.transform(utf8.decoder).join();
        print(
            'Failed to update product: ${response.statusCode} - $responseBody');
      }
    } catch (error) {
      print('Error submitting product: $error');
    } finally {
      httpClient.close();
    }
  }
}

Future<Map<String, dynamic>?> fetchProfileData(String username) async {
  final url =
      Uri.parse('http://194.147.222.179:3005/api/product/status/$username');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // Log the error and return null
      print('Failed to load user profile data: ${response.statusCode}');
      return null; // Return null for non-200 responses
    }
  } catch (e) {
    print('Error fetching user profile data: $e');
    return null; // Return null in case of an error
  }
}
