import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salemina_data/classes/product.dart';
import 'package:salemina_data/screens/home/not_found_product_alarm.dart';
import 'package:salemina_data/services/api_service.dart';
import 'package:salemina_data/shared/styled_banner.dart';
import 'package:salemina_data/shared/styled_button.dart';
import 'package:salemina_data/shared/styled_text_field.dart';
import 'package:salemina_data/widgets/sample_image.dart';
import 'package:salemina_data/widgets/styled_divider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    required this.barcode,
    required this.username,
    this.product,
    this.isScanned,
  });

  final String barcode;
  final String username;
  final Product? product;
  final bool? isScanned;

  @override
  State<ProductPage> createState() => _ProductPageInputState();
}

class _ProductPageInputState extends State<ProductPage> {
  final picker = ImagePicker();
  File? _image;
  File? _mainImage;
  File? _extraImage;

  String productMainCode = '';
  String prodcutExtracode = '';

  late TextEditingController _perController;
  late TextEditingController _calorieController;
  late TextEditingController _sugerController;
  late TextEditingController _fatController;
  late TextEditingController _saltController;
  late TextEditingController _transFattyAcidsController;
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _calorieExt;
  late TextEditingController _calFat;
  late TextEditingController _saturatedFat;
  late TextEditingController _totalFat;
  late TextEditingController _transFat;
  late TextEditingController _unsaturatedFat;
  late TextEditingController _carbohydrate;
  late TextEditingController _protein;
  late TextEditingController _saltExt;
  late TextEditingController _sugarExt;
  late TextEditingController _sodium;
  late TextEditingController _fiber;
  late TextEditingController _cholesterol;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _perController = TextEditingController(text: widget.product?.per ?? '');
    _calorieController =
        TextEditingController(text: widget.product?.calorie ?? '');
    _fatController = TextEditingController(text: widget.product?.fat ?? '');
    _sugerController = TextEditingController(text: widget.product?.sugar ?? '');
    _saltController = TextEditingController(text: widget.product?.salt ?? '');
    _transFattyAcidsController =
        TextEditingController(text: widget.product?.transFattyAcids ?? '');
    _totalFat = TextEditingController(text: widget.product?.totalFat ?? '');
    _nameController =
        TextEditingController(text: widget.product?.productName ?? '');
    _brandController = TextEditingController(text: widget.product?.brand ?? '');
    _calorieExt = TextEditingController(text: widget.product?.calorieExt ?? '');
    _calFat = TextEditingController(text: widget.product?.calFat ?? '');
    _saturatedFat =
        TextEditingController(text: widget.product?.saturatedFat ?? '');
    _transFat = TextEditingController(text: widget.product?.transFat ?? '');
    _unsaturatedFat =
        TextEditingController(text: widget.product?.unsaturatedFat ?? '');
    _carbohydrate =
        TextEditingController(text: widget.product?.carbohydrate ?? '');
    _protein = TextEditingController(text: widget.product?.protein ?? '');
    _saltExt = TextEditingController(text: widget.product?.salt ?? '');
    _sugarExt = TextEditingController(text: widget.product?.sugar ?? '');
    _sodium = TextEditingController(text: widget.product?.sodium ?? '');
    _fiber = TextEditingController(text: widget.product?.fiber ?? '');
    _cholesterol =
        TextEditingController(text: widget.product?.cholesterol ?? '');
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _nameController.dispose();
    _brandController.dispose();
    _perController.dispose();
    _calorieController.dispose();
    _sugerController.dispose();
    _fatController.dispose();
    _saltController.dispose();
    _transFattyAcidsController.dispose();
    _calFat.dispose();
    _totalFat.dispose();
    _saturatedFat.dispose();
    _unsaturatedFat.dispose();
    _transFat.dispose();
    _protein.dispose();
    _sugarExt.dispose();
    _carbohydrate.dispose();
    _fiber.dispose();
    _saltExt.dispose();
    _sodium.dispose();
    _cholesterol.dispose();
  }

  Future<void> _pickImage(
      ImageSource source, Function(File) onImagePicked) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    }
  }

  Future<void> _showImageOptions(Function(File) onImagePicked) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.gallery, onImagePicked);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.camera, onImagePicked);
            },
          ),
        ],
      ),
    );
  }

  void _updateProductMainCode() {
    setState(() {
      productMainCode = (_perController.text != widget.product!.per ||
              _calorieController.text != widget.product!.calorie ||
              _fatController.text != widget.product!.fat ||
              _sugerController.text != widget.product!.sugar ||
              _transFattyAcidsController.text !=
                  widget.product!.transFattyAcids ||
              _saltController.text != widget.product!.salt)
          ? '3'
          : '11';
    });
  }

  Future<void> _submitData(
      String barcode, String? situation, bool isMainData) async {
    if (_isDataValid(isMainData)) {
      _updateProductMainCode();
      final productData = _buildProductData(barcode);
      await _sendProductData(barcode, productData, situation);
    }
  }

  bool _isDataValid(bool isMainData) {
    if ((_image == null && widget.product?.pictureNew == '') ||
        (_mainImage == null && widget.product?.pictureMainInfo == '')) {
      styledBanner(context, 'عکس محصول اجباری می باشد');
      return false;
    }
    if (isMainData &&
        (_perController.text.isEmpty ||
            _calorieController.text.isEmpty ||
            _fatController.text.isEmpty ||
            _sugerController.text.isEmpty ||
            _transFattyAcidsController.text.isEmpty ||
            _saltController.text.isEmpty)) {
      styledBanner(context, 'فیلدهای اجباری را وارد کنید');
      return false;
    }
    if (!isMainData && _extraImage == null) {
      styledBanner(context, 'عکس اطلاعات تکمیلی اجباری می باشد');
      return false;
    }
    return true;
  }

  Map<String, dynamic> _buildProductData(String barcode) {
    return {
      'child_cluster': '',
      'product_name': _nameController.text,
      'brand': _brandController.text,
      'barcode': barcode,
      'picture_old': '',
      'product_description': '',
      'per': _perController.text,
      'calorie': _calorieController.text,
      'sugar': _sugerController.text,
      'fat': _fatController.text,
      'salt': _saltController.text,
      'trans_fatty_acids': _transFattyAcidsController.text,
      'Main_data_status': productMainCode,
      'Extra_data_status': prodcutExtracode,
      'importer': widget.username,
      'monitor': "",
      'cluster': '',
      'picture_new': widget.product?.pictureNew == ''
          ? _image!.path.split('/').last
          : widget.product?.pictureNew,
      'picture_main_info': widget.product?.pictureMainInfo == ''
          ? _mainImage!.path.split('/').last
          : widget.product?.pictureMainInfo,
      'picture_extra_info':
          _extraImage != null ? _extraImage!.path.split('/').last : '',
      'per_ext': '',
      'calorie_ext': _calorieExt.text,
      'cal-fat': _calFat.text,
      'total_fat': _totalFat.text,
      'saturated_fat': _saturatedFat.text,
      'unsaturated_fat': _unsaturatedFat.text,
      'trans_fat': _transFat.text,
      'protein': _protein.text,
      'sugar_ext': _sugarExt.text,
      'carbohydrate': _carbohydrate.text,
      'fiber': _fiber.text,
      'salt_ext': _saltExt.text,
      'sodium': _sodium.text,
      'cholesterol': _cholesterol.text
    };
  }

  Future<void> _sendProductData(String barcode,
      Map<String, dynamic> productData, String? situation) async {
    final url = Uri.parse('http://194.147.222.179:3005/api/product/$barcode');
    final httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    try {
      final request = await httpClient.putUrl(url);
      request.headers.set('Content-Type', 'application/json');
      request.add(utf8.encode(jsonEncode(productData)));
      final response = await request.close();

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessMessage(situation);
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

  void _showSuccessMessage(String? situation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "اطلاعات با موفقیت تایید شد",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        duration: Duration(seconds: 2),
      ),
    );
    if (situation == 'final') {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.product == null ? 'ورود محصول جدید' : 'ویرایش محصول موجود'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.product == null) const NotFoundProductAlarm(),
            _buildBarcodeField(),
            if (widget.product != null &&
                widget.product!.pictureOld!.isNotEmpty)
              _buildProductImage(),
            _buildSampleImages(),
            _buildImageOptions(),
            const StyledDivider(text: 'فیلدهای اجباری اصلی'),
            _buildMainFields(),
            const StyledDivider(text: 'فیلدهای اختیاری اصلی'),
            _buildOptionalFields(),
            if (widget.product != null) _buildSubmitMainDataButton(),
            const StyledDivider(text: 'اطلاعات تکمیلی محصول'),
            _buildExtraInfoSection(),
            _buildExtraFields(),
            if (widget.product != null) _buildSubmitExtraDataButton(),
            _buildFinalSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBarcodeField() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          readOnly: true,
          controller: TextEditingController(text: widget.barcode),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          textDirection: TextDirection.rtl,
          decoration: const InputDecoration(
            labelText: 'بارکد',
            labelStyle: TextStyle(
                color: Color.fromARGB(255, 40, 40, 40),
                fontSize: 12,
                fontWeight: FontWeight.w400),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(
          widget.product!.pictureOld!,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: const Text('آدرس تصویر محصول درست نمی باشد'),
                    ),
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSampleImages() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: const Color.fromARGB(250, 250, 238, 147),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'نمونه عکس‌های قابل قبول ',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 38, 38, 38)),
          ),
          const SampleImage(),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Text(
              'برای مشاهده جزئیات بیشتر روی عکس‌ها ضربه بزنید',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 38, 38, 38)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildImageOptions() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () => _showImageOptions((file) => _image = file),
              child: const StyledButton("افزودن عکس برچسب رنگی محصول")),
          InkWell(
              onTap: () => _showImageOptions((file) => _mainImage = file),
              child: const StyledButton("افزودن عکس محصول")),
        ],
      ),
    );
  }

  Widget _buildMainFields() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledTextField(
                  labelText: "کالری", controller: _calorieController),
              StyledTextField(labelText: "per", controller: _perController),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledTextField(labelText: "قند", controller: _sugerController),
              StyledTextField(labelText: "چربی", controller: _fatController),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledTextField(labelText: "نمک", controller: _saltController),
              StyledTextField(
                  labelText: "اسید چرب ترانس",
                  controller: _transFattyAcidsController),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionalFields() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StyledTextField(labelText: "برند", controller: _brandController),
          StyledTextField(labelText: "نام کامل", controller: _nameController),
        ],
      ),
    );
  }

  Widget _buildSubmitMainDataButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _submitData(widget.barcode, '', true),
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.9,
              height: 45,
              margin: const EdgeInsets.only(top: 10, bottom: 30),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'تایید اطلاعات اصلی محصول',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtraInfoSection() {
    return Container(
      margin: const EdgeInsets.only(top: 0, right: 20, left: 20, bottom: 10),
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
      width: MediaQuery.of(context).size.width * 1.0,
      decoration: BoxDecoration(
        color: const Color.fromARGB(250, 250, 238, 147),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'نمونه عکس‌ قابل قبول ',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 38, 38, 38)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Image.asset(
                            'assets/extrainfopicture1.jpg',
                            width: 250,
                            height: 300,
                          ),
                        );
                      },
                    );
                  },
                  child: Image.asset(
                    'assets/extrainfopicture1.jpg',
                    width: 150,
                    height: 100,
                    color: const Color.fromARGB(250, 250, 238, 147),
                    colorBlendMode: BlendMode.multiply,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Text(
              'برای مشاهده جزئیات بیشتر روی عکس ضربه بزنید',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 38, 38, 38)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildExtraFields() {
    return Column(
      children: [
        InkWell(
            onTap: () => _showImageOptions((file) => _extraImage = file),
            child: const StyledButton("افزودن عکس اطلاعات تکمیلی")),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledTextField(labelText: "کالری کل", controller: _calorieExt),
              StyledTextField(labelText: "per", controller: _calFat),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledTextField(
                  labelText: "چربی اشباع", controller: _saturatedFat),
              StyledTextField(labelText: "چربی کل", controller: _totalFat),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledTextField(labelText: "چربی ترانس", controller: _transFat),
              StyledTextField(
                  labelText: "چربی غیر اشباع", controller: _unsaturatedFat),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledTextField(
                  labelText: "کربوهیدرات", controller: _carbohydrate),
              StyledTextField(labelText: "*پروتئین", controller: _protein),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledTextField(labelText: "نمک کل", controller: _saltExt),
              StyledTextField(labelText: "قند", controller: _sugarExt),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledTextField(labelText: "سدیم", controller: _sodium),
              StyledTextField(labelText: "*فیبر", controller: _fiber),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StyledTextField(labelText: "کلسترول", controller: _cholesterol),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitExtraDataButton() {
    return InkWell(
      onTap: () => _submitData(widget.barcode, null, false),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.9,
        height: 45,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text(
          'تایید اطلاعات تکمیلی محصول',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildFinalSubmitButton() {
    return InkWell(
      onTap: () {
        if (_perController.text.isEmpty ||
            _calorieController.text.isEmpty ||
            _fatController.text.isEmpty ||
            _sugerController.text.isEmpty ||
            _transFattyAcidsController.text.isEmpty ||
            _saltController.text.isEmpty) {
          styledBanner(context, 'اطلاعات اجباری را وارد کنید');
        } else if (widget.product == null) {
          submitNewProduct(
            context,
            widget.barcode,
            _image,
            _mainImage,
            _extraImage,
            widget.username,
            _calorieExt,
            _totalFat,
            _saturatedFat,
            _unsaturatedFat,
            _transFat,
            _protein,
            _carbohydrate,
            _sugarExt,
            _saltExt,
            _cholesterol,
            _sodium,
            _nameController,
            _brandController,
            _perController,
            _calorieController,
            _sugerController,
            _fatController,
            _saltController,
            _transFattyAcidsController,
            _fiber,
            _calFat,
          );
        } else {
          _submitData(widget.barcode, 'final', true);
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.9,
        height: 45,
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          widget.product == null ? 'ثبت' : 'ثبت نهایی محصول',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
