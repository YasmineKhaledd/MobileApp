
class Company {
  int id;
  String companyName;
  String contactPersonName;
  List<String> companyIndustry;
  String phoneNumber;
  String email;
  String companyAddress;
  String companyLocation;
  String companySize;
  String password;

  Company({
    required this.id,
    required this.companyName,
    required this.contactPersonName,
    required this.companyIndustry,
    required this.phoneNumber,
    required this.email,
    required this.companyAddress,
    required this.companyLocation,
    required this.companySize,
    required this.password,
  });

  get profilePhotoUrl => null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyName': companyName,
      'contactPersonName': contactPersonName,
      'companyIndustry': companyIndustry.join(','),
      'phoneNumber': phoneNumber,
      'email': email,
      'companyAddress': companyAddress,
      'companyLocation': companyLocation,
      'companySize': companySize,
      'password': password,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'],
      companyName: map['companyName'],
      contactPersonName: map['contactPersonName'],
      companyIndustry: (map['companyIndustry'] as String).split(','),
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      companyAddress: map['companyAddress'],
      companyLocation: map['companyLocation'],
      companySize: map['companySize'],
      password: map['password'],
    );
  }
}