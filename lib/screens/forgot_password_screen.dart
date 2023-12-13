import 'package:cm_flutter_app/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailTextEditingController = TextEditingController();

  //GlobalKey
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    firebaseAuth.sendPasswordResetEmail(
        email: emailTextEditingController.text.trim()
    ).then((value){
      Fluttertoast.showToast(msg: "We have sent you an email to recover password, pls check your email");
    }).onError((error, stackTrace){
      Fluttertoast.showToast(msg: "Error Ocurred \n ${error.toString()}");
    });
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
                    'Forgot Password',
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
                            //LoginButton
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                  onPrimary: darkTheme ? Colors.black : Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  minimumSize:  const Size(double.infinity, 50)
                              ),
                              onPressed: (){
                                _submit();
                              },
                              child: const Text(
                                "Send Reset Password Link",
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            //ForgotPassword
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
                                  "Already have an account?",
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
                                      "Login",
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
