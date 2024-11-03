import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salemina_data/classes/product.dart';
import 'package:salemina_data/screens/home/product_page.dart';
import 'package:salemina_data/screens/profile/ProfilePage.dart';
import 'package:salemina_data/services/curved_top_clipper.dart';
import '/methods/login.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String scannedBarcode = 'No barcode scanned yet.';
  final _barcodeController = TextEditingController();
  final _username = ValueNotifier<String>('');
  final _password = TextEditingController();
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoginPopup(context, _username, _password);
    });
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> scanBarcode() async {
    try {
      final scanResult = await BarcodeScanner.scan();
      final scannedBarcode = scanResult.rawContent;

      if (scannedBarcode.isNotEmpty &&
          scannedBarcode.length == 13 &&
          int.tryParse(scannedBarcode) != null) {
        setState(() {
          this.scannedBarcode = scannedBarcode;
        });

        final product = await fetchProductData(scannedBarcode);
        navigateToProductPage(scannedBarcode, product);
      } else {
        showInvalidBarcodeMessage();
      }
    } catch (e) {
      setState(() {
        scannedBarcode = 'Failed to get barcode: $e';
      });
    }
  }

  Future<Product?> fetchProductData(String barcode) async {
    final url = 'http://194.147.222.179:3005/api/product/$barcode';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Product.fromJson(jsonData);
      } else if (response.statusCode == 400) {
        // Handle specific error response
        return null; // Return null if the product is not found
      } else {
        print('Failed to load product data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching product data: $e');
      return null;
    }
  }

  void navigateToProductPage(String barcode, dynamic product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ProductPage(
          barcode: barcode,
          username: _username.value,
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
              _buildProfileButton(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
              Image.asset('assets/logo.png'),
              _buildScannerSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton() {
    return ValueListenableBuilder<String>(
      valueListenable: _username,
      builder: (context, username, child) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(username: username),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Baseline(
                  baseline: 20.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 26,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScannerSection() {
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
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
          InkWell(
            onTap: () async {
              if (barcodeValidator(_barcodeController.text)) {
                final product = await fetchProductData(_barcodeController.text);
                navigateToProductPage(_barcodeController.text, product);
                _barcodeController.clear();
              } else {
                showInvalidBarcodeMessage();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.14,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.02),
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
                  left: MediaQuery.of(context).size.width * 0.02),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: _barcodeController,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    labelText: "بارکد محصول را وارد کنید",
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 40, 40, 40),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
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
          ),
        ],
      ),
    );
  }
}
