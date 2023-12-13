import 'package:cm_flutter_app/screens/forgot_password_screen.dart';
import 'package:cm_flutter_app/screens/resgister_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../global/global.dart';
import 'main_page_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {

  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  bool _passwordVisible = false;

  //GlobalKey
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    //validate all the fields
    if(_formKey.currentState!.validate()) {
      await firebaseAuth.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim()
      ).then((auth) async {
        currentUser = auth.user;

        await Fluttertoast.showToast(msg: "Successfully Logged In");
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
      onTap: () {
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
                      'Login',
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
                              //LoginButton
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
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 20
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              //ForgotPassword
                              GestureDetector(
                                onTap:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (c) => ForgotPasswordScreen()));
                                },
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
                                    "Don't have an account?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (c) => RegisterScreen()));
                                    },
                                    child: Text(
                                        "Register",
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
