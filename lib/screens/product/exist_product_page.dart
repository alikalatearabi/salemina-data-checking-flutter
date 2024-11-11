import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:salemina_data/classes/product.dart';
import 'package:salemina_data/screens/home/home.dart';
import 'package:salemina_data/services/product_service.dart';
import 'package:salemina_data/widgets/sample_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExistProductPage extends StatefulWidget {
  final String barcode;
  final Product product;

  const ExistProductPage(
      {super.key, required this.barcode, required this.product});

  @override
  ExistProductPageState createState() => ExistProductPageState();
}

class ExistProductPageState extends State<ExistProductPage> {
  @override
  void initState() {
    super.initState();
    _loadUsername();
    _initializeControllers();
    _storeInitialValues();
  }

  final TextEditingController calorieController = TextEditingController();
  final TextEditingController perController = TextEditingController();
  final TextEditingController sugarController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController saltController = TextEditingController();
  final TextEditingController transFatController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();

  final TextEditingController calorieExtController = TextEditingController();
  final TextEditingController extraPerController = TextEditingController();
  final TextEditingController saturatedFatController = TextEditingController();
  final TextEditingController totalFatController = TextEditingController();
  final TextEditingController transFatExtController = TextEditingController();
  final TextEditingController unsaturatedFatController =
      TextEditingController();
  final TextEditingController carbohydrateController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController saltExtController = TextEditingController();
  final TextEditingController sugarExtController = TextEditingController();
  final TextEditingController sodiumController = TextEditingController();
  final TextEditingController fiberController = TextEditingController();
  final TextEditingController cholesterolController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _mainImage;
  File? _infoImage;
  File? _extraImage;
  String _username = '';

  bool _isMainImageUploaded = false;
  bool _isInfoImageUploaded = false;
  bool _isExtraImageUploaded = false;

  bool _isMainDataReadOnly = false;
  bool _isExtraDataReadOnly = false;

  late String initialCalorie;
  late String initialPer;
  late String initialSugar;
  late String initialFat;
  late String initialSalt;
  late String initialTransFat;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 70,
              left: 30,
              right: 30,
              bottom: 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackIcon(),
                _buildBarcodeField(),
                const SizedBox(height: 20),
                _buildOldImage(),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(66, 94, 94, 94),
                        blurRadius: 5.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(250, 250, 238, 147),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'نمونه عکس های صحیح',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SampleImage(),
                          ],
                        ),
                      ),
                      _buildHeaderWithLine('فیلدهای اجباری اصلی'),
                      _buildImageButtons(),
                      const SizedBox(height: 10),
                      _buildMainProductInfo(),
                      const SizedBox(height: 20),
                      _buildHeaderWithLine('فیلدهای اختیاری اصلی'),
                      const SizedBox(height: 10),
                      _buildMainProductExtraInfo(),
                      const SizedBox(height: 20),
                      _buildSubmitButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(66, 94, 94, 94),
                        blurRadius: 5.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(250, 250, 238, 147),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'نمونه عکس های صحیح',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: Image.asset(
                                        'assets/extrainfopicture1.jpg',
                                        width: 300,
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
                      _buildHeaderWithLine('فیلدهای تکمیلی'),
                      _buildExtraImageButton(),
                      const SizedBox(height: 10),
                      _buildExtraProductInfo(),
                      const SizedBox(height: 20),
                      _buildSubmitExtraButton(),
                    ],
                  ),
                ),
                _buildFinishOperationButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
    });
  }

  void _initializeControllers() {
    calorieController.text = widget.product.calorie ?? '';
    perController.text = widget.product.per ?? '';
    sugarController.text = widget.product.sugar ?? '';
    fatController.text = widget.product.fat ?? '';
    saltController.text = widget.product.salt ?? '';
    transFatController.text = widget.product.transFattyAcids ?? '';
    nameController.text = widget.product.productName ?? '';
    brandController.text = widget.product.brand ?? '';

    calorieExtController.text = widget.product.calorieExt ?? '';
    extraPerController.text = widget.product.perExt ?? '';
    saturatedFatController.text = widget.product.saturatedFat ?? '';
    totalFatController.text = widget.product.totalFat ?? '';
    transFatExtController.text = widget.product.transFat ?? '';
    unsaturatedFatController.text = widget.product.unsaturatedFat ?? '';
    carbohydrateController.text = widget.product.carbohydrate ?? '';
    proteinController.text = widget.product.protein ?? '';
    saltExtController.text = widget.product.saltExt ?? '';
    sugarExtController.text = widget.product.sugarExt ?? '';
    sodiumController.text = widget.product.sodium ?? '';
    fiberController.text = widget.product.fiber ?? '';
    cholesterolController.text = widget.product.cholesterol ?? '';
  }

  void _storeInitialValues() {
    initialCalorie = calorieController.text;
    initialPer = perController.text;
    initialSugar = sugarController.text;
    initialFat = fatController.text;
    initialSalt = saltController.text;
    initialTransFat = transFatController.text;
  }

  bool _hasMainDataChanged() {
    return calorieController.text != initialCalorie ||
        perController.text != initialPer ||
        sugarController.text != initialSugar ||
        fatController.text != initialFat ||
        saltController.text != initialSalt ||
        transFatController.text != initialTransFat;
  }

  Future<void> _showImageOptions(
      Function(File) onImagePicked, String imageType) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery'),
            onTap: () async {
              Navigator.of(context).pop();
              final pickedFile =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                onImagePicked(File(pickedFile.path));
                _updateImageUploadStatus(imageType, true);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () async {
              Navigator.of(context).pop();
              final pickedFile =
                  await _picker.pickImage(source: ImageSource.camera);
              if (pickedFile != null) {
                onImagePicked(File(pickedFile.path));
                _updateImageUploadStatus(imageType, true);
              }
            },
          ),
        ],
      ),
    );
  }

  void _updateImageUploadStatus(String imageType, bool status) {
    setState(() {
      if (imageType == 'main') {
        _isMainImageUploaded = status;
      } else if (imageType == 'info') {
        _isInfoImageUploaded = status;
      } else if (imageType == 'extra') {
        _isExtraImageUploaded = status;
      }
    });
  }

  Future<void> _confirmAndSubmitMainData() async {
    final confirmed = await _showConfirmationDialog(
        "با انجام این عمل دیگر قادر به تغییر نمی باشید");
    if (confirmed) {
      await _submitMainData();
    }
  }

  Future<void> _confirmAndSubmitExtraData() async {
    final confirmed = await _showConfirmationDialog(
        "با انجام این عمل دیگر قادر به تغییر نمی باشید");
    if (confirmed) {
      await _submitExtraData();
    }
  }

  Future<bool> _showConfirmationDialog(String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('OK'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _submitMainData() async {
    if (_mainImage == null ||
        _infoImage == null ||
        calorieController.text.isEmpty ||
        perController.text.isEmpty ||
        sugarController.text.isEmpty ||
        fatController.text.isEmpty ||
        saltController.text.isEmpty ||
        transFatController.text.isEmpty) {
      _showErrorDialog("لطفا تمام فیلدهای اجباری را وارد کنید");
      return;
    }

    final mainDataStatus = _hasMainDataChanged() ? '3' : '11';

    final productData = {
      'Main_data_status': mainDataStatus,
      'Extra_data_status': '',
      'importer': _username,
      'monitor': '',
      'cluster': '',
      'child_cluster': '',
      'product_name': nameController.text,
      'brand': brandController.text,
      'picture_old': '',
      'picture_new': _mainImage!.path.split('/').last,
      'picture_main_info': _infoImage!.path.split('/').last,
      'picture_extra_info': '',
      'product_description': '',
      'barcode': widget.barcode,
      'state_of_matter': '0',
      'per': perController.text,
      'calorie': calorieController.text,
      'sugar': sugarController.text,
      'fat': fatController.text,
      'salt': saltController.text,
      'trans_fatty_acids': transFatController.text,
      'per_ext': '',
      'calorie_ext': '',
      'cal_fat': '',
      'total_fat': '',
      'saturated_fat': '',
      'unsaturated_fat': '',
      'trans_fat': '',
      'protein': '',
      'sugar_ext': '',
      'carbohydrate': '',
      'fiber': '',
      'salt_ext': '',
      'sodium': '',
      'cholesterol': '',
    };

    final url =
        Uri.parse('http://194.147.222.179:3005/api/product/${widget.barcode}');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog("داده های اصلی با موفقیت ثبت شد");
        setState(() {
          _isMainDataReadOnly = true;
        });
        Future.microtask(_checkIfSubmissionComplete);
      } else {
        _showErrorDialog("خطا در ثبت داده های اصلی");
      }
    } catch (e) {
      _showErrorDialog("خطا در ارتباط با سرور: $e");
    }
  }

  Future<void> _submitExtraData() async {
    if (_extraImage == null) {
      _showErrorDialog("لطفا عکس اطلاعات تکمیلی را وارد کنید");
      return;
    }

    final mainDataStatus = _hasMainDataChanged() ? '3' : '11';

    final extraData = {
      'Main_data_status': mainDataStatus,
      'Extra_data_status': '7',
      'importer': _username,
      'monitor': '',
      'cluster': '',
      'child_cluster': '',
      'product_name': nameController.text,
      'brand': brandController.text,
      'picture_old': '',
      'picture_new': _mainImage!.path.split('/').last,
      'picture_main_info': _infoImage!.path.split('/').last,
      'picture_extra_info': _extraImage!.path.split('/').last,
      'product_description': '',
      'barcode': widget.barcode,
      'state_of_matter': '0',
      'per': perController.text,
      'calorie': calorieController.text,
      'sugar': sugarController.text,
      'fat': fatController.text,
      'salt': saltController.text,
      'trans_fatty_acids': transFatController.text,
      'per_ext': extraPerController.text,
      'calorie_ext': calorieExtController.text,
      'cal_fat': '',
      'total_fat': totalFatController.text,
      'saturated_fat': saturatedFatController.text,
      'unsaturated_fat': unsaturatedFatController.text,
      'trans_fat': transFatExtController.text,
      'protein': proteinController.text,
      'sugar_ext': sugarExtController.text,
      'carbohydrate': carbohydrateController.text,
      'fiber': fiberController.text,
      'salt_ext': saltExtController.text,
      'sodium': sodiumController.text,
      'cholesterol': cholesterolController.text,
    };

    final url =
        Uri.parse('http://194.147.222.179:3005/api/product/${widget.barcode}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(extraData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      _showSuccessDialog("اطلاعات تکمیلی با موفقیت ثبت شد");
      setState(() {
        _isExtraDataReadOnly = true;
      });
      Future.microtask(_checkIfSubmissionComplete);
    } else {
      _showErrorDialog("خطا در ثبت اطلاعات تکمیلی");
    }
  }

  void _checkIfSubmissionComplete() {
    if (_isMainDataReadOnly && _isExtraDataReadOnly) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => const MyHomePage()),
      );
      _showSuccessDialog("محصول با موفقیت ثبت شد");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            border: Border.all(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: TextStyle(color: Colors.red.shade900),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'باشه',
              style: TextStyle(color: Colors.red.shade900),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
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

  Widget _buildBackIcon() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildBarcodeField() {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: widget.barcode),
      decoration: const InputDecoration(
        labelText: 'بارکد',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildOldImage() {
    return FutureBuilder(
      future: _loadOldImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Text('Failed to load image');
        } else if (snapshot.hasData && snapshot.data != null) {
          return Image.network(
            snapshot.data as String,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Text('Failed to load image');
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<String?> _loadOldImage() async {
    if (widget.product.pictureOld != null &&
        widget.product.pictureOld!.isNotEmpty) {
      return widget.product.pictureOld;
    }
    return null;
  }

  Widget _buildHeaderWithLine(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(
          color: Colors.black,
          thickness: 2,
        ),
      ],
    );
  }

  Widget _buildImageButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showImageOptions((file) {
              setState(() {
                _mainImage = file;
              });
              uploadMainImageApi(context, file);
            }, 'main'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color:
                      _isMainImageUploaded ? Colors.green : Colors.transparent,
                  width: 2.0,
                ),
              ),
            ),
            child: const Text(
              'افزودن عکس محصول',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showImageOptions((file) {
              setState(() {
                _infoImage = file;
              });
              uploadInfoImageApi(context, file);
            }, 'info'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color:
                      _isInfoImageUploaded ? Colors.green : Colors.transparent,
                  width: 2.0,
                ),
              ),
            ),
            child: const Text(
              'افزودن عکس برچسب رنگی',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainProductInfo() {
    return Column(
      children: [
        _buildInputRow('کالری', calorieController, 'per', perController),
        _buildInputRow('قند', sugarController, 'چربی', fatController),
        _buildInputRow(
            'نمک', saltController, 'اسید چرب ترانس', transFatController),
      ],
    );
  }

  Widget _buildMainProductExtraInfo() {
    return Column(
      children: [
        _buildInputRow('نام', nameController, 'برند', brandController),
      ],
    );
  }

  Widget _buildExtraImageButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showImageOptions((file) {
              setState(() {
                _extraImage = file;
              });
              uploadExtraImageApi(context, file);
            }, 'extra'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color:
                      _isExtraImageUploaded ? Colors.green : Colors.transparent,
                  width: 2.0,
                ),
              ),
            ),
            child: const Text(
              'افزودن عکس اطلاعات تکمیلی',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExtraProductInfo() {
    return Column(
      children: [
        _buildExtraInputRow(
            'کالری کل', calorieExtController, 'extra per', extraPerController),
        _buildExtraInputRow('چربی اشباع', saturatedFatController, 'چربی کل',
            totalFatController),
        _buildExtraInputRow('چربی ترانس', transFatExtController,
            'چربی غیر اشباع', unsaturatedFatController),
        _buildExtraInputRow(
            'کربوهیدرات', carbohydrateController, 'پروتئین', proteinController),
        _buildExtraInputRow(
            'نمک کل', saltExtController, 'قند اضافه', sugarExtController),
        _buildExtraInputRow('سدیم', sodiumController, 'فیبر', fiberController),
        _buildExtraInputRow(
            'کلسترول', cholesterolController, '', TextEditingController()),
      ],
    );
  }

  Widget _buildInputRow(
    String label1,
    TextEditingController controller1,
    String label2,
    TextEditingController controller2,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: _buildTextField(label1, controller1, _isMainDataReadOnly),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: label2.isNotEmpty
                ? _buildTextField(label2, controller2, _isMainDataReadOnly)
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildExtraInputRow(
    String label1,
    TextEditingController controller1,
    String label2,
    TextEditingController controller2,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: _buildTextField(label1, controller1, _isExtraDataReadOnly),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: label2.isNotEmpty
                ? _buildTextField(label2, controller2, _isExtraDataReadOnly)
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool readOnly,
  ) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            color: Color.fromARGB(255, 40, 40, 40),
            fontSize: 12,
            fontWeight: FontWeight.w400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 192, 180, 180),
            width: 1.0,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        fillColor: readOnly ? Colors.grey.shade200 : Colors.white,
        filled: true,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _confirmAndSubmitMainData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text(
              'تایید داده اصلی',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitExtraButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _confirmAndSubmitExtraData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text(
              'تایید اطلاعات تکمیلی محصول',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinishOperationButton() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _finishOperation,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: const Text(
          'اتمام عملیات',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  void _finishOperation() {
    if (_isMainDataReadOnly) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => const MyHomePage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'عملیات بر روی محصول به پایان رسید',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'لطفا ابتدا داده‌های اصلی را تایید کنید',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
