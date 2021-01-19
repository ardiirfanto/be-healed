import 'package:be_healed/screens/signup_screen.dart';
import 'package:be_healed/services/auth_service.dart';
import 'package:be_healed/services/input_login_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screeen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //FORM LOGIN
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  _submit() {
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        //Logging in the user w/ Firebase
        AuthService.login(_email, _password);
      }
    } catch (e) {
      print("Error = " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.lightBlueAccent, Colors.purpleAccent]),
          ),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.deepPurple),
              ),
              SizedBox(height: 30.0),
              Text(
                'be HealEd',
                style: TextStyle(
                  fontFamily: 'Comfortaa-SemiBold',
                  fontSize: 50,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 25.0),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
                      child: RoundedInputField(
                        hintText: "Your Email",
                        onChanged: (input) => _email = input,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
                      child: RoundedPasswordField(
                        onChanged: (input) => _password = input,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: size.width * 0.5,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: RaisedButton(
                          onPressed: _submit,
                          color: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 40),
                          child: Text(
                            'Log in',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text("Don't have an account?",
                        style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        )),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: size.width * 0.5,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: RaisedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, SignupScreen.id),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 40),
                          color: Colors.purple[50],
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
