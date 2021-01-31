import 'package:be_healed/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String currentUserId;

  ChangePasswordScreen({
    this.currentUserId,
  });

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  // String _password = '';
  // String _reenter = '';
  TextEditingController _password = TextEditingController();
  TextEditingController _reenter = TextEditingController();
  bool _isLoading = false;

  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      AuthService.updatePassword(_password.text);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          'Ganti Password',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Comfortaa-SemiBold',
            fontSize: 25.0,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.lightBlueAccent, Colors.purpleAccent]),
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _isLoading
                          ? Center(
                              child: SpinKitRing(
                                color: Colors.deepPurple,
                                size: 25.0,
                                lineWidth: 3.0,
                              ),
                            )
                          : SizedBox.shrink(),
                      TextFormField(
                        obscureText: true,
                        controller: _password,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
                            size: 30.0,
                          ),
                          labelText: 'Password',
                        ),
                        validator: (input) => input.length < 6
                            ? 'Must be at least 6 characters'
                            : null,
                        // onSaved: (input) => _password = input,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _reenter,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
                            size: 30.0,
                          ),
                          labelText: 'Re-enter Password',
                        ),
                        validator: (input) => input != _password.text
                            ? 'Password doesn\'t match'
                            : null,
                        // onSaved: (input) => _reenter = input,
                      ),
                      Container(
                        margin: EdgeInsets.all(40.0),
                        height: 40.0,
                        width: 150.0,
                        child: FlatButton(
                          onPressed: _submit,
                          color: Colors.lightGreen,
                          textColor: Colors.white,
                          child: Text(
                            'Save Password',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
