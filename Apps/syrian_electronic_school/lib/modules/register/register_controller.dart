import 'package:get/get.dart';
import '../../models/classes.dart';
import './register_service.dart';
import '../../models/user.dart';
class RegisterController extends GetxController {
  var firstName = "";
  var lastName = "";
  var email = "";
  var password = "";
  var passwordConfirm = "";
  var phoneNumber = "";
  //DateTime date_of_birth = DateTime.now();
  var date_of_birth = "";
  var education_level = 0;

  RegisterService service = RegisterService();
  var registerStatus = false;
  var msg;
  var error;

  var classes = <Class>[].obs; // Observable list of classes
  var selectedClass; // Selected class


  @override
  void onInit() {
    super.onInit();
    fetchClasses();
  }



  Future<void> fetchClasses() async {
    try {
      var fetchedClasses = await service.fetchClasses();
      classes.assignAll(fetchedClasses); // Assign fetched classes to the observable list
    } catch (e) {
      // Handle error if needed
    }
  }
  Future<void> registerOnClick() async {
    //print("F name :" + firstName + "L name :"+ lastName + '\n'+ "email :" + email + "phone :"+ phoneNumber + '\n'+ "date of birth :" +date_of_birth +"edu :"+ education_level.toString()  );

    User user =User(firstName: firstName,lastName: lastName,email:email,password:password,phoneNumber: phoneNumber,dateOfBirth: date_of_birth,interest:education_level );
    registerStatus = await service.register(user);
    msg = service.msg;
    error=service.error;
    if(error is List){
      String temp ='';
      for (String s in error) temp +=s+'\n';
      error=temp;
    }
  }
}