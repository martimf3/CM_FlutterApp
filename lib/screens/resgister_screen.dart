import 'package:cm_flutter_app/screens/login_screen.dart';
import 'package:cm_flutter_app/screens/main_page_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cm_flutter_app/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();

  bool _passwordVisible = false;

  //declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    //validate all the fields
    if(_formKey.currentState!.validate()) {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim()
      ).then((auth) async {
        currentUser = auth.user;

        if(currentUser != null){
          Map userMap = {
            "id": currentUser!.uid,
            "name": nameTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "address": addressTextEditingController.text.trim(),
            "phone": phoneTextEditingController.text.trim(),
          };
          DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
          userRef.child(currentUser!.uid).set(userMap);
        }
        await Fluttertoast.showToast(msg: "Successfully Registered");
        Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Error occured: \n $errorMessage}");
      });
    }
    else{
      Fluttertoast.showToast(msg: "Not all fields are valid");
    }
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Column(
              children: [
                Image.asset(darkTheme ? 'images/city_dark.jpg' : 'images/city.jpg'),

                const SizedBox(height: 28),

                Text(
                  'Register',
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  )
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Name
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )
                                ),
                                prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey)
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if(text == null || text.isEmpty){
                                  return "Name can't be empty";
                                }
                                if(text.length < 2) {
                                  return "Please enter a valid name";
                                }
                                if(text.length > 50){
                                  return "Name can't have more thant 50 letters";
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() {
                                nameTextEditingController.text = text;
                              })
                            ),
                            const SizedBox(height: 20),
                            //Email
                            TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100)
                                ],
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        )
                                    ),
                                    prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey)
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if(EmailValidator.validate(text!) == true){
                                    return null;
                                  }
                                  if(text.isEmpty){
                                    return "email can't be empty";
                                  }
                                  if(text.length < 2) {
                                    return "Please enter a valid email";
                                  }
                                  if(text.length > 50){
                                    return "Email can't have more thant 100 characters";
                                  }
                                  return null;
                                },
                                onChanged: (text) => setState(() {
                                  emailTextEditingController.text = text;
                                })
                            ),
                            const SizedBox(height: 20),
                            //PhoneNumber
                            IntlPhoneField(
                              showCountryFlag: false,
                              dropdownIcon: Icon(
                                Icons.arrow_drop_down,
                                color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                              ),
                              decoration: InputDecoration(
                                  hintText: "Phone Number",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      )
                                  ),
                              ),
                              initialCountryCode: '620',
                              onChanged: (text) => setState(() {
                                phoneTextEditingController.text = text.completeNumber;
                              }),
                            ),
                            //Address
                            TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100)
                                ],
                                decoration: InputDecoration(
                                    hintText: "Address",
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        )
                                    ),
                                    prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey)
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if(text == null || text.isEmpty){
                                    return "Address can't be empty";
                                  }
                                  if(text.length < 2) {
                                    return "Please enter a valid address";
                                  }
                                  if(text.length > 50){
                                    return "Address can't have more thant 100 characters";
                                  }
                                  return null;
                                },
                                onChanged: (text) => setState(() {
                                  addressTextEditingController.text = text;
                                })
                            ),
                            const SizedBox(height: 20),
                            //Password
                            TextFormField(
                              obscureText: !_passwordVisible,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        )
                                    ),
                                    prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: darkTheme ? Colors.amber.shade400 :Colors.grey,
                                    ),
                                    onPressed: () {
                                      //Alter visibility of password characters
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  )
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if(text == null || text.isEmpty){
                                    return "Password can't be empty";
                                  }
                                  if(text.length < 2) {
                                    return "Please enter a valid password";
                                  }
                                  if(text.length > 50){
                                    return "Password can't have more thant 50 characters";
                                  }
                                  return null;
                                },
                                onChanged: (text) => setState(() {
                                  passwordTextEditingController.text = text;
                                })
                            ),
                            const SizedBox(height: 20),
                            //ConfirmPassword
                            TextFormField(
                                obscureText: !_passwordVisible,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                decoration: InputDecoration(
                                    hintText: " Confirm Password",
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        )
                                    ),
                                    prefixIcon: Icon(Icons.person, color: darkTheme ? Colors.amber.shade400 : Colors.grey),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                        color: darkTheme ? Colors.amber.shade400 :Colors.grey,
                                      ),
                                      onPressed: () {
                                        //Alter visibility of password characters
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    )
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (text) {
                                  if(text == null || text.isEmpty){
                                    return "Password can't be empty";
                                  }
                                  if(text != passwordTextEditingController.text){
                                    return "Passwords do not match";
                                  }
                                  if(text.length < 6) {
                                    return "Please enter a valid password";
                                  }
                                  if(text.length > 50){
                                    return "Password can't have more thant 50 characters";
                                  }
                                  return null;
                                },
                                onChanged: (text) => setState(() {
                                  confirmTextEditingController.text = text;
                                })
                            ),
                            const SizedBox(height: 20),
                            //RegisterButton
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                onPrimary: darkTheme ? Colors.black : Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                minimumSize:  Size(double.infinity, 50)
                              ),
                                onPressed: (){
                                _submit();
                                },
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                ),
                            ),
                            //ForgotPassword
                            const SizedBox(height: 20),
                            GestureDetector(
                            onTap:(){},
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                  color: darkTheme ? Colors.amber.shade400 : Colors.blue
                                ),
                              ),
                            ),
                            //LoginButton
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                    "Have an account?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (c) => LogInScreen()));
                                  },
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: darkTheme ? Colors.amber.shade400 : Colors.blue
                                    )
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
