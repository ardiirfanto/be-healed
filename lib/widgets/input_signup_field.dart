import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NameInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const NameInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        validator: (input) =>
            input.trim().isEmpty ? 'Please enter a valid name' : null,
        cursorColor: Colors.deepPurple,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.deepPurple,
          ),
          hintText: hintText,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class EmailInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const EmailInputField({
    Key key,
    this.hintText,
    this.icon = Icons.mail,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        validator: (input) =>
            !input.contains('@') ? 'Please enter a valid email address' : null,
        cursorColor: Colors.deepPurple,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.deepPurple,
          ),
          hintText: hintText,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class PhoneNumberInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final TextInputFormatter inputFormatter;

  const PhoneNumberInputField({
    Key key,
    this.hintText,
    this.icon = Icons.contact_phone_rounded,
    this.onChanged,
    this.keyboardType,
    this.inputFormatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        validator: (input) =>
            input.contains('*') ? 'Please enter a valid phoneNumber' : null,
        cursorColor: Colors.deepPurple,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.deepPurple,
          ),
          hintText: hintText,
          disabledBorder: InputBorder.none,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}

class PasswordInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const PasswordInputField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: true,
        onChanged: onChanged,
        validator: (input) =>
            input.length < 6 ? 'Must be at least 6 characters' : null,
        cursorColor: Colors.deepPurple,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Colors.deepPurple,
          ),
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
