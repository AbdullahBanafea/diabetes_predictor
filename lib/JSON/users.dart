class Users {
  final int? usrId;
  final String? fullName;
  final String? phoneNumber;
  final String email;
  final String password;
  final String? bloodSugarLevel;
  final String? profilePhotoPath;

  Users({
    this.usrId,
    this.fullName,
    this.phoneNumber,
    required this.email,
    required this.password,
    this.bloodSugarLevel,
    this.profilePhotoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'usrId': usrId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'usrPassword': password,
      'bloodSugarLevel': bloodSugarLevel,
      'profilePhotoPath': profilePhotoPath,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      usrId: map['usrId'] as int?,
      fullName: map['fullName'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      email: map['email'] as String,
      password: map['usrPassword'] as String,
      bloodSugarLevel: map['bloodSugarLevel'] as String?,
      profilePhotoPath: map['profilePhotoPath'] as String?,
    );
  }
}