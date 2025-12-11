import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:intl/intl.dart';
import 'package:smart_medical_clinic/modules/register/register_controller.dart';
import 'package:smart_medical_clinic/shared_widget/custom_snack_bar.dart';

import '../../models/user.dart';
import '../theme/themeController.dart';
import 'register_service.dart';

class Register extends StatelessWidget {
  RegisterController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 89, 155, 222),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                // Logo
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset("assets/images/logo22.png"),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                // Title
                Text('Create your account',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),

                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                _buildEmailField(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                _buildPasswordField(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                _buildConfirmPasswordField(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                _buildGenderField(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                _buildDateOfBirthField(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                _buildRelationshipStatusField(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                _buildNumberOfKidsField(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                _buildJobField(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                _buildWorkHoursField(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                _buildPlaceOfWorkField(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Obx(() {
                  if (controller.isLoading.value) {
                    return CircularProgressIndicator();
                  } else {
                    return ElevatedButton(
                      onPressed: () {
                        controller.formSubmitted.value = true;
                        if (_formKey.currentState!.validate()) {
                          _handleRegistration(context);
                        }
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 21, 56, 85),
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.7,
                            MediaQuery.of(context).size.height * 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    );
                  }
                }),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                GestureDetector(
                  child: Text(
                    "Already have an account? sign in here",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 21, 56, 85)),
                  ),
                  onTap: () {
                    Get.offNamed('Login');
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Email Field
  Widget _buildEmailField() {
    return _styledTextField(
      hintText: 'Email',
      icon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      controller: controller.emailController,
      validator: (value) => EmailValidator.validate(value ?? '')
          ? null
          : 'Please enter a valid email',
    );
  }

// Password Field
  Widget _buildPasswordField() {
    return _styledTextField(
      hintText: 'Password',
      icon: Icons.lock,
      obscureText: true,
      controller: controller.passwordController,
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
    );
  }

// Confirm Password Field
  Widget _buildConfirmPasswordField() {
    return _styledTextField(
      hintText: 'Confirm Password',
      icon: Icons.lock_outline,
      obscureText: true,
      controller: controller.confirmPasswordController,
      validator: (value) {
        if (value != controller.passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

// Number of Kids Field
  Widget _buildNumberOfKidsField() {
    return _styledTextField(
      hintText: 'Number of Kids (Optional)',
      icon: Icons.child_care,
      keyboardType: TextInputType.number,
      controller: controller.nocController,
      validator: (value) {
        if (value != null &&
            value.isNotEmpty &&
            (int.tryParse(value) == null || int.parse(value) > 15)) {
          return 'Please enter a valid number (0-15)';
        }
        return null;
      },
    );
  }

// Work Hours Field
  Widget _buildWorkHoursField() {
    return _styledTextField(
      hintText: 'Work Hours per Day (Optional)',
      icon: Icons.access_time,
      keyboardType: TextInputType.number,
      controller: controller.howController,
      validator: (value) {
        if (value != null &&
            value.isNotEmpty &&
            (int.tryParse(value) == null ||
                int.parse(value) < 1 ||
                int.parse(value) > 16)) {
          return 'Please enter a valid number (1-16)';
        }
        return null;
      },
    );
  }

// Place of Work Field
  Widget _buildPlaceOfWorkField() {
    return _styledTextField(
      hintText: 'Place of Work (Optional)',
      controller: controller.powController,
      icon: Icons.location_city,
    );
  }

  Widget _styledTextField({
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 163, 192, 222),
            Color.fromARGB(255, 127, 176, 226),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Color.fromARGB(255, 21, 56, 85)),
            hintText: hintText,
            hintStyle: TextStyle(color: Color.fromARGB(255, 21, 56, 85)),
            border: GradientOutlineInputBorder(
              gradient: LinearGradient(colors: [Colors.white, Colors.blue]),
              width: 2,
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: GradientOutlineInputBorder(
              gradient: LinearGradient(colors: [Colors.white, Colors.blue]),
              width: 2,
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: GradientOutlineInputBorder(
              gradient: LinearGradient(colors: [Colors.white, Colors.blue]),
              width: 2,
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.transparent,
            filled: true,
            errorStyle: TextStyle(color: Colors.red)),
        style: TextStyle(color: Color.fromARGB(255, 21, 56, 85)),
      ),
    );
  }

  Widget _buildRelationshipStatusField(BuildContext context) {
    return Obx(() => Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 163, 192, 222),
                Color.fromARGB(255, 127, 176, 226),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(brightness: Brightness.light),
            child: DropdownButtonFormField<String?>(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.family_restroom,
                      color: Color.fromARGB(255, 21, 56, 85)),
                  errorStyle: TextStyle(color: Colors.red)),
              value: controller.selectedRelationshipStatus.value,
              onChanged: (String? newValue) {
                controller.selectedRelationshipStatus.value = newValue;
                controller.formSubmitted.value =
                    false; // Reset submission flag on user action
              },
              hint: Text("Relationship Status",
                  style: TextStyle(color: Color.fromARGB(255, 21, 56, 85))),
              validator: (_) {
                if (controller.formSubmitted.isTrue &&
                    controller.selectedRelationshipStatus.value == null) {
                  return 'Please select your relationship status';
                }
                return null;
              },
              dropdownColor: Colors.white,
              items: <String>[
                'Single',
                'Married',
                'Divorced',
                'Widowed',
                'In a relationship'
              ].map<DropdownMenuItem<String?>>((String value) {
                return DropdownMenuItem<String?>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(color: Color.fromARGB(255, 21, 56, 85))),
                );
              }).toList(),
            ),
          ),
        ));
  }

  Widget _buildGenderField(BuildContext context) {
    return Obx(() => Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 163, 192, 222),
                Color.fromARGB(255, 127, 176, 226),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(brightness: Brightness.light),
            child: DropdownButtonFormField<String?>(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.family_restroom,
                      color: Color.fromARGB(255, 21, 56, 85)),
                  errorStyle: TextStyle(color: Colors.red)),
              value: controller.selectedGender.value,
              onChanged: (String? newValue) {
                controller.selectedGender.value = newValue;
                controller.formSubmitted.value =
                    false; // Reset submission flag on user action
              },
              hint: Text("Gender",
                  style: TextStyle(color: Color.fromARGB(255, 21, 56, 85))),
              validator: (_) {
                if (controller.formSubmitted.isTrue &&
                    controller.selectedGender.value == null) {
                  return 'Please select your gender';
                }
                return null;
              },
              dropdownColor: Colors.white,
              items: <String>['Male', 'Female']
                  .map<DropdownMenuItem<String?>>((String value) {
                return DropdownMenuItem<String?>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(color: Color.fromARGB(255, 21, 56, 85))),
                );
              }).toList(),
            ),
          ),
        ));
  }

  Widget _buildDateOfBirthField(BuildContext context) {
    return Obx(() {
      bool showError = controller.formSubmitted.isTrue &&
          controller.selectedDateOfBirth.value == null;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 163, 192, 222),
                  Color.fromARGB(255, 127, 176, 226),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: GestureDetector(
              onTap: () async {
                DateTime now = DateTime.now();
                DateTime firstDate =
                    DateTime(now.year - 80, now.month, now.day);
                DateTime lastDate = DateTime(now.year - 14, now.month, now.day);

                // Ensure initialDate is within the range if selectedDateOfBirth is not set.
                DateTime initialDate = controller.selectedDateOfBirth.value ??
                    DateTime(now.year - 18, now.month, now.day);
                // Adjust initialDate if it's out of bounds.
                if (initialDate.isBefore(firstDate)) {
                  initialDate = firstDate;
                } else if (initialDate.isAfter(lastDate)) {
                  initialDate = lastDate;
                }

                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: firstDate,
                  lastDate: lastDate,
                );
                if (picked != null &&
                    picked != controller.selectedDateOfBirth.value) {
                  controller.selectedDateOfBirth.value = picked;
                  controller.formSubmitted.value =
                      false; // Reset submission flag on user action
                }
              },
              child: Container(
                height: 60, // Fixed height for alignment
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: Color.fromARGB(255, 21, 56, 85)),
                    SizedBox(width: 10), // Space between icon and text
                    Expanded(
                      child: Text(
                        controller.selectedDateOfBirth.value != null
                            ? "Date of Birth: ${controller.selectedDateOfBirth.value!.day}/${controller.selectedDateOfBirth.value!.month}/${controller.selectedDateOfBirth.value!.year}"
                            : "Select your date of birth",
                        style: TextStyle(
                            color: Color.fromARGB(255, 21, 56, 85),
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showError)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Please select your date of birth',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildJobField(BuildContext context) {
    return Obx(() => Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 163, 192, 222),
                Color.fromARGB(255, 127, 176, 226),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(brightness: Brightness.light),
            child: DropdownButtonFormField<String?>(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon:
                      Icon(Icons.work, color: Color.fromARGB(255, 21, 56, 85)),
                  errorStyle: TextStyle(color: Colors.red)),
              value: controller.selectedJob.value,
              onChanged: (String? newValue) {
                controller.selectedJob.value = newValue;
                controller.formSubmitted.value =
                    false; // Reset submission flag on user action
              },
              hint: Text("Current work",
                  style: TextStyle(color: Color.fromARGB(255, 21, 56, 85))),
              validator: (_) {
                if (controller.formSubmitted.isTrue &&
                    controller.selectedJob.value == null) {
                  return 'Please select your current work';
                }
                return null;
              },
              dropdownColor: Colors.white,
              items: <String>[
                'Student',
                'Healthcare',
                'IT',
                'Construction',
                'None'
              ].map<DropdownMenuItem<String?>>((String value) {
                return DropdownMenuItem<String?>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(color: Color.fromARGB(255, 21, 56, 85))),
                );
              }).toList(),
            ),
          ),
        ));
  }

  void _handleRegistration(BuildContext context) async {
    controller.isLoading.value = true; // Show loading indicator
    controller.formSubmitted.value = true;
    if (_formKey.currentState!.validate()) {
      // Create a User object from the form data
      bool? genderBool;
      if (controller.selectedGender.value == 'Male') {
        genderBool = true;
      } else if (controller.selectedGender.value == 'Female') {
        genderBool = false;
      }
      // Format the date of birth
      String formattedDateOfBirth = controller.selectedDateOfBirth.value != null
          ? DateFormat('yyyy-MM-dd')
              .format(controller.selectedDateOfBirth.value!)
          : '';

      User newUser = User(
        email: controller.email.value,
        password: controller.password.value,
        dob: formattedDateOfBirth,
        gender: genderBool,
        maritalstatus: controller.selectedRelationshipStatus.value,
        noc: controller.noc.value,
        profession: controller.selectedJob.value,
        hof: controller.how.value,
        pow: controller.pow.value,
      );

      // Call the register service
      bool isRegistered = await RegisterService().register(newUser);
      controller.isLoading.value = false;
      if (isRegistered) {
        await storage.write(key: 'userEmail', value: newUser.email);
        customSnackBar(
            "Registration successful", "check your email for the code",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed("/OTP");
      } else {
        customSnackBar("Error",
            "Registration failed: ${RegisterService.error}", // Access static error variable
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    }
  }
}
