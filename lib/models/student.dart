class Student {
  int? id;
  String name;
  String idType;
  String idNumber;
  String? governorate;
  String? district;
  String? village;
  String? isolation;
  String? specialization;
  String? level;
  String? phone;

  Student({
    this.id,
    required this.name,
    required this.idType,
    required this.idNumber,
    this.governorate,
    this.district,
    this.village,
    this.isolation,
    this.specialization,
    this.level,
    this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'idType': idType,
      'idNumber': idNumber,
      'governorate': governorate,
      'district': district,
      'village': village,
      'isolation': isolation,
      'specialization': specialization,
      'level': level,
      'phone': phone,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      idType: map['idType'],
      idNumber: map['idNumber'],
      governorate: map['governorate'],
      district: map['district'],
      village: map['village'],
      isolation: map['isolation'],
      specialization: map['specialization'],
      level: map['level'],
      phone: map['phone'],
    );
  }
}
