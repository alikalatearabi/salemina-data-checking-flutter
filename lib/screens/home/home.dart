// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, deprecated_member_use, sized_box_for_whitespace
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:salemina_data/classes/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salemina_data/screens/home/product_page.dart';
import 'package:salemina_data/screens/profile/ProfilePage.dart';
import 'package:salemina_data/services/curved_top_clipper.dart';
import '/methods/login.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String scannedBarcode = 'No barcode scanned yet.';

  late TextEditingController _barcodeController;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _brandController = TextEditingController();
  final _perController = TextEditingController();
  final _calorieController = TextEditingController();
  final _sugerController = TextEditingController();
  final _fatController = TextEditingController();
  final _saltController = TextEditingController();
  final _trans_fatty_acidsController = TextEditingController();
  final _Cal_fat = TextEditingController();
  final _total_fat = TextEditingController();
  final _saturated_fat = TextEditingController();
  final _unsaturated_fat = TextEditingController();
  final _trans_fat = TextEditingController();
  final _protein = TextEditingController();
  final _sugar_ext = TextEditingController();
  final _carbohydrate = TextEditingController();
  final _fiber = TextEditingController();
  final _salt_ext = TextEditingController();
  final _sodium = TextEditingController();
  final _cholesterol = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool isTextBox = false;
  final picker = ImagePicker();
  String username = '';

  @override
  void initState() {
    super.initState();

    _barcodeController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoginPopup(context, _username, _password);
    });
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _brandController.dispose();
    _perController.dispose();
    _calorieController.dispose();
    _sugerController.dispose();
    _fatController.dispose();
    _saltController.dispose();
    _trans_fatty_acidsController.dispose();
    _Cal_fat.dispose();
    _total_fat.dispose();
    _saturated_fat.dispose();
    _unsaturated_fat.dispose();
    _trans_fat.dispose();
    _protein.dispose();
    _sugar_ext.dispose();
    _carbohydrate.dispose();
    _fiber.dispose();
    _salt_ext.dispose();
    _sodium.dispose();
    _cholesterol.dispose();
    super.dispose();
  }

  Future<void> scanBarcode() async {
    try {
      ScanResult scanResult;
      String scannedBarcode;

      do {
        scanResult = await BarcodeScanner.scan();
        scannedBarcode = scanResult.rawContent;

        if (scannedBarcode.isEmpty) {
          return;
        }

        if (scannedBarcode.length == 13 &&
            int.tryParse(scannedBarcode) != null) {
          setState(() {
            scannedBarcode = scannedBarcode;
          });

          final product = await fetchProductData(scannedBarcode);

          if (product == null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => ProductPage(
                  barcode: scannedBarcode,
                  username: _username.text,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => ProductPage(
                  barcode: scannedBarcode,
                  username: _username.text,
                  product: product,
                ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  'بارکد صحیح نیست',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } while (scannedBarcode.isEmpty);
    } catch (e) {
      setState(() {
        scannedBarcode = 'Failed to get barcode: $e';
      });
    }
  }

  Future<dynamic> fetchProductData(String barcode) async {
    final url = 'http://194.147.222.179:3005/api/product/${barcode}';
    HttpClient httpClient = HttpClient();
    try {
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final jsonData = jsonDecode(responseBody);
        return Product.fromJson(jsonData);
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'این محصول از قبل بررسی و ثبت شده است.',
                style: TextStyle(fontSize: 18),
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return 'not_found';
      } else {
        print('Failed to load product data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching product data: $e');
      return null;
    } finally {
      httpClient.close();
    }
  }

  bool barcodeValidator(BuildContext context, String barcode) {
    if (_barcodeController.text.length == 13 && int.tryParse(barcode) != null) {
      return true;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          'بارکد صحیح نیست',
          style: TextStyle(fontSize: 18),
        ),
      ),
      backgroundColor: Colors.red,
    ));

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: const Color.fromARGB(248, 255, 255, 255),
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black, // Black background
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            username: _username.text,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Baseline(
                          baseline: 20.0, // Adjust based on icon size
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            _username.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 26,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                Image.asset('assets/logo.png'),
                Center(
                  child: ClipPath(
                    clipper: CurvedTopClipper(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              'برای اسکن محصولات بعد از کلیک بر روی گزینه اسکن بارکد محصول،‌بارکد آن را  در مقابل دوربین قرار دهید. همچنین می‌توانید بارکد را به صورت دستی وارد نمایید.',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              scanBarcode();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 25),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black,
                              ),
                              child: const Center(
                                  child: Text(
                                'اسکن بارکد محصول',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            margin: const EdgeInsets.only(top: 40),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (barcodeValidator(
                                        context, _barcodeController.text)) {
                                      final product = await fetchProductData(
                                        _barcodeController.text,
                                      );
                                      if (product != null &&
                                          product != 'not_found') {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (ctx) => ProductPage(
                                              barcode: _barcodeController.text,
                                              username: _username.text,
                                              product: product,
                                            ),
                                          ),
                                        );
                                      } else if (product == null) {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) => ProductPage(
                                                barcode:
                                                    _barcodeController.text,
                                                username: _username.text,
                                              ),
                                            ));
                                      }
                                      _barcodeController.text = '';
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.14,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(5)),
                                    margin: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    child: const Icon(
                                      Icons.search,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: TextField(
                                        controller: _barcodeController,
                                        textDirection: TextDirection.rtl,
                                        decoration: InputDecoration(
                                          labelText: "بارکد محصول را وارد کنید",
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 40, 40, 40),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 0.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 0.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
        )));
  }
}
