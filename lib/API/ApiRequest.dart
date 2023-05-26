class DrugModel {
  final String brandName;
  final String name;
  final String strength;

  DrugModel(
      {required this.brandName, required this.name, required this.strength});

  factory DrugModel.fromJson(Map<String, dynamic> json){
    return DrugModel(
        brandName: json['brand_name'],
        name: json['active_ingredients'][0]['name'],
        strength: json['active_ingredients'][0]['strength']);
  }
}