import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salemina_data/services/product_service.dart';

class NewProductPage extends StatefulWidget {
  final String barcode;

  const NewProductPage({super.key, required this.barcode});

  @override
  NewProductPageState createState() => NewProductPageState();
}

class NewProductPageState extends State<NewProductPage> {
  final TextEditingController calorieController = TextEditingController();
  final TextEditingController perController = TextEditingController();
  final TextEditingController sugarController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController saltController = TextEditingController();
  final TextEditingController transFatController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _mainImage;
  File? _infoImage;

  Future<void> _showImageOptions(Function(File) onImagePicked) async {
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
              }
            },
          ),
        ],
      ),
    );
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
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBarcodeField(),
              const SizedBox(height: 20),
              _buildHeaderWithLine('فیلدهای اجباری اصلی'),
              _buildImageButtons(),
              const SizedBox(height: 10),
              _buildMainProductInfo(),
            ],
          ),
        ),
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
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
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
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
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
            child: _buildTextField(label1, controller1),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildTextField(label2, controller2),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
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
      ),
    );
  }
}
