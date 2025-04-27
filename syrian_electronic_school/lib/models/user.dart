class User {
  String? firstName;
  String? lastName;
  //DateTime ? dateOfBirth;
  String? dateOfBirth;
  String? phoneNumber;
  String? email;
  String? password;
  int? interest;
  User(
      {this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.phoneNumber,
      this.dateOfBirth,
      this.interest});
}
