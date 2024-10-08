
class Product {
  String? childCluster;
  String? productName;
  String? brand;
  String? pictureOld;
  String? pictureNew;
  String? pictureMainInfo;
  String? pictureExtraInfo;
  String? productDescription;
  final String barcode;
  String? stateOfMatter;
  String? per;
  String? calorie;
  String? sugar;
  String? fat;
  String? salt;
  String? transFattyAcids;
  String? perExt;
  String? calorieExt;
  String? calFat;
  String? totalFat;
  String? saturatedFat;
  String? unsaturatedFat;
  String? transFat;
  String? protein;
  String? sugarExt;
  String? carbohydrate;
  String? fiber;
  String? saltExt;
  String? sodium;
  String? cholesterol;
  String? importer;
  String? mainDataStatus;
  String? extraDataStatus;
  String? monitor;
  String? cluster;

  Product({
    this.childCluster,
    this.productName,
    this.brand,
    this.pictureOld,
    this.pictureNew,
    this.pictureMainInfo,
    this.pictureExtraInfo,
    this.productDescription,
    required this.barcode,
    this.stateOfMatter,
    this.per,
    this.calorie,
    this.sugar,
    this.fat,
    this.salt,
    this.transFattyAcids,
    this.perExt,
    this.calorieExt,
    this.calFat,
    this.totalFat,
    this.saturatedFat,
    this.unsaturatedFat,
    this.transFat,
    this.protein,
    this.sugarExt,
    this.carbohydrate,
    this.fiber,
    this.saltExt,
    this.sodium,
    this.cholesterol,
    this.importer,
    this.mainDataStatus,
    this.extraDataStatus,
    this.monitor,
    this.cluster,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      childCluster: json['child_cluster'],
      productName: json['product_name'],
      brand: json['brand'],
      pictureOld: json['picture_old'],
      pictureNew: json['picture_new'],
      pictureMainInfo: json['picture_main_info'],
      pictureExtraInfo: json['picture_extra_info'],
      productDescription: json['product_description'],
      barcode: json['barcode'],
      stateOfMatter: json['state_of_matter'],
      per: json['per'],
      calorie: json['calorie'],
      sugar: json['sugar'],
      fat: json['fat'],
      salt: json['salt'],
      transFattyAcids: json['trans_fatty_acids'],
      perExt: json['per_ext'],
      calorieExt: json['calorie_ext'],
      calFat: json['cal_fat'],
      totalFat: json['total_fat'],
      saturatedFat: json['saturated_fat'],
      unsaturatedFat: json['unsaturated_fat'],
      transFat: json['trans_fat'],
      protein: json['protein'],
      sugarExt: json['sugar_ext'],
      carbohydrate: json['carbohydrate'],
      fiber: json['fiber'],
      saltExt: json['salt_ext'],
      sodium: json['sodium'],
      cholesterol: json['cholesterol'],
      importer: json['importer'],
      mainDataStatus: json['Main_data_status'],
      extraDataStatus: json['Extra_data_status'],
      monitor: json['monitor'],
      cluster: json['cluster'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'child_cluster': childCluster,
      'product_name': productName,
      'brand': brand,
      'picture_old': pictureOld,
      'picture_new': pictureNew,
      'picture_main_info': pictureMainInfo,
      'picture_extra_info': pictureExtraInfo,
      'product_description': productDescription,
      'barcode': barcode,
      'state_of_matter': stateOfMatter,
      'per': per,
      'calorie': calorie,
      'sugar': sugar,
      'fat': fat,
      'salt': salt,
      'trans_fatty_acids': transFattyAcids,
      'per_ext': perExt,
      'calorie_ext': calorieExt,
      'cal_fat': calFat,
      'total_fat': totalFat,
      'saturated_fat': saturatedFat,
      'unsaturated_fat': unsaturatedFat,
      'trans_fat': transFat,
      'protein': protein,
      'sugar_ext': sugarExt,
      'carbohydrate': carbohydrate,
      'fiber': fiber,
      'salt_ext': saltExt,
      'sodium': sodium,
      'cholesterol': cholesterol,
      'importer': importer,
      'Main_data_status': mainDataStatus,
      'Extra_data_status': extraDataStatus,
      'monitor': monitor,
      'cluster': cluster,
    };
  }
}
