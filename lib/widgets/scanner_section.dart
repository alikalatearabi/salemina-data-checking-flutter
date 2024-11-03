import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:salemina_data/classes/product.dart';
import 'package:salemina_data/screens/home/product_page.dart';
import 'dart:convert';
import 'dart:io';

import 'package:salemina_data/services/curved_top_clipper.dart';

class ScannerSection extends StatefulWidget {
  final TextEditingController barcodeController;
  final String username;

  const ScannerSection({
    super.key,
    required this.barcodeController,
    required this.username,
  });

  @override
  ScannerSectionState createState() => ScannerSectionState();
}

class ScannerSectionState extends State<ScannerSection> {
  Future<void> scanBarcode() async {
    try {
      final scanResult = await BarcodeScanner.scan();
      final scannedBarcode = scanResult.rawContent;

      if (scannedBarcode.isNotEmpty && int.tryParse(scannedBarcode) != null) {
        final product = await fetchProductData(scannedBarcode);
        if (product != 'error400') {
          navigateToProductPage(scannedBarcode, product);
        }
      } else {
        showInvalidBarcodeMessage();
      }
    } catch (e) {
      print('Failed to get barcode: $e');
    }
  }

  Future<dynamic> fetchProductData(String barcode) async {
    final url = 'http://194.147.222.179:3005/api/product/$barcode';
    final httpClient = HttpClient();

    try {
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        return Product.fromJson(jsonDecode(responseBody));
      } else if (response.statusCode == 400) {
        showProductAlreadyRegisteredMessage();
        return 'error400';
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

  void navigateToProductPage(String barcode, dynamic product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ProductPage(
          barcode: barcode,
          username: widget.username,
          product: product,
        ),
      ),
    );
  }

  void showInvalidBarcodeMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
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

  void showProductAlreadyRegisteredMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
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
  }

  bool barcodeValidator(String barcode) {
    return barcode.length == 13 && int.tryParse(barcode) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipPath(
        clipper: CurvedTopClipper(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.5,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildScannerInstructions(),
              _buildScanButton(),
              _buildManualBarcodeEntry(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerInstructions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: const Text(
        'برای اسکن محصولات بعد از کلیک بر روی گزینه اسکن بارکد محصول،‌بارکد آن را  در مقابل دوربین قرار دهید. همچنین می‌توانید بارکد را به صورت دستی وارد نمایید.',
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildScanButton() {
    return InkWell(
      onTap: scanBarcode,
      child: Container(
        margin: const EdgeInsets.only(top: 25),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black,
        ),
        child: const Center(
          child: Text(
            'اسکن بارکد محصول',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildManualBarcodeEntry() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      margin: const EdgeInsets.only(top: 40),
      child: Row(
        children: [
          _buildSearchButton(),
          _buildBarcodeTextField(),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return InkWell(
      onTap: () async {
        if (barcodeValidator(widget.barcodeController.text)) {
          final product = await fetchProductData(widget.barcodeController.text);
          if (product != 'error400') {
            navigateToProductPage(widget.barcodeController.text, product);
          }
          widget.barcodeController.clear();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.14,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        margin:
            EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
        child: const Icon(
          Icons.search,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBarcodeTextField() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextField(
            controller: widget.barcodeController,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              labelText: "بارکد محصول را وارد کنید",
              labelStyle: TextStyle(
                  color: Color.fromARGB(255, 40, 40, 40),
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
