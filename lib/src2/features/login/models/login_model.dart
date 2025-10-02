class LoginModel{
  String deviceToken;
  String usuario;
  String password;
  LoginModel({
    required this.deviceToken,
    required this.usuario,
    required this.password,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    deviceToken: json["deviceToken"],
    usuario: json["usuario"],
    password: json["password"],
  );

  Map<String, dynamic> toMap() => {
    "deviceToken": deviceToken,
    "usuario": usuario,
    "password": password,
  };
}