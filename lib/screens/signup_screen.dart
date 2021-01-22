import 'package:be_healed/services/auth_service.dart';
import 'package:be_healed/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:be_healed/widgets/input_signup_field.dart';
import 'package:expandable_text/expandable_text.dart';

class SignupScreen extends StatefulWidget {
  static final String id = 'signup_screeen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _phoneNumber, _password;
  bool agree = false;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_name);
      print(_email);
      print(_phoneNumber);
      print(_password);

      //Signing up the user w/ Firebase
      AuthService.signUpUser(context, _name, _email, _phoneNumber, _password);
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
                colors: [Colors.deepPurple, Colors.white]),
          ),
          child: BackgroundTwo(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Text(
                      "SIGN UP",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'be HealEd',
                      style: TextStyle(
                        fontFamily: 'Comfortaa-SemiBold',
                        fontSize: 50,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 5.0),
                            child: NameInputField(
                              hintText: "Your Name",
                              onChanged: (input) => _name = input,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 5.0),
                            child: EmailInputField(
                              hintText: "Your Email",
                              onChanged: (input) => _email = input,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 5.0),
                            child: PhoneNumberInputField(
                              hintText: "Your Phone Number",
                              onChanged: (input) => _phoneNumber = input,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 5.0),
                            child: PasswordInputField(
                              onChanged: (input) => _password = input,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Informed Consent",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black45),
                                ),
                                SizedBox(height: 5.0),
                                ExpandableText(
                                  "Konseling adalah suatu proses bersifat rahasia yang ditujukan agar kamu dapat mengatasi masalah kamu, memahami dirimu dan juga belajar untuk strategi coping baik personal dan interpersonal. Konseling juga termasuk berbagi informasi pribadi  yang bersifat rahasia dan sensitif. Selama proses konseling mungkin akan ada masa di mana ada peningkatan kecemasan dan kebingungan. Hasil konseling seringkali positif, meskipun tingkat kepuasan konseli/klien tidak dapat diprediksi. \n\nKERAHASIAAN \nSemua interaksi dengan layanan konseling, termasuk perencanaan jadwal perjanjian konseling, isi dari sesi konseling, dan catatan/riwayat proses konseling kamu besifat RAHASIA. \n\nPENGECUALIAN TERHADAP KERAHASIAAN \nJika ada keinginan konseli yang dengan jelas dan sengaja ingin menyakiti diri sendiri ataupun orang lain, maka konselor wajib melaporkan kepada orang yang menjadi emergency contact, supervisor ataupun pihak yang berwenang.",
                                  expandText: 'Show more',
                                  collapseText: 'Show less',
                                  maxLines: 3,
                                  linkColor: Colors.blue,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black45),
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Checkbox(
                                      activeColor: Colors.deepPurple,
                                      hoverColor: Colors.green,
                                      value: agree,
                                      onChanged: (value) {
                                        setState(() {
                                          agree = value;
                                        });
                                      },
                                    ),
                                    Container(
                                      width: 230.0,
                                      child: Text(
                                        'Dengan ini, saya menyatakan telah membaca, memahami, dan menyetujui informed consent di atas.',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            width: size.width * 0.5,
                            height: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(29),
                              child: RaisedButton(
                                onPressed: agree ? _submit : null,
                                color: Colors.deepPurple,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                child: Text(
                                  'Sign Up',
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
                          Text("Already have an account?",
                              style: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            width: size.width * 0.5,
                            height: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(29),
                              child: RaisedButton(
                                onPressed: () => Navigator.pop(context),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                color: Colors.purple[50],
                                child: Text(
                                  'Back to Login',
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
          ),
        ),
      ),
    );
  }
}
