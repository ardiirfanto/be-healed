import 'dart:io';

import 'package:be_healed/services/auth_service.dart';
import 'package:be_healed/services/storage_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:be_healed/models/user_model.dart';
import 'package:be_healed/services/database_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  final Function updateUser;

  EditProfileScreen({this.user, this.updateUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File _profileImage;
  String _name = '';
  String _bio = '';
  String _email = '';
  String _phoneNumber = '';
  String _age = '';
  String _gender = '';
  String _address = '';
  String _role = '';
  String _chattingWith = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
    _email = widget.user.email;
    _phoneNumber = widget.user.phoneNumber;
    _age = widget.user.age;
    _gender = widget.user.gender;
    _address = widget.user.address;
    _role = widget.user.role;
    _chattingWith = widget.user.chattingWith;
  }

  _handleImageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _profileImage = imageFile;
      });
    }
  }

  _displayProfileImage() {
    // No new profile image
    if (_profileImage == null) {
      // No existing profile image
      if (widget.user.profileImageUrl.isEmpty) {
        // Display placeholder
        return AssetImage('assets/images/user_placeholder.jpg');
      } else {
        // User profile image exists
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    } else {
      // New profile image
      return FileImage(_profileImage);
    }
  }

  _submit() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      // Update user in database
      String _profileImageUrl = '';

      if (_profileImage == null) {
        _profileImageUrl = widget.user.profileImageUrl;
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
          widget.user.profileImageUrl,
          _profileImage,
        );
      }

      User user = User(
        id: widget.user.id,
        name: _name,
        profileImageUrl: _profileImageUrl,
        bio: _bio,
        email: _email,
        phoneNumber: _phoneNumber,
        age: _age,
        gender: _gender,
        address: _address,
        role: _role,
        chattingWith: _chattingWith,
      );
      // Database update
      DatabaseService.updateUser(user);
      AuthService.updateEmail(_email);
      widget.updateUser(user);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          'Edit Profile',
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
              _isLoading
                  ? Center(
                      child: SpinKitRing(
                        color: Colors.deepPurple,
                        size: 25.0,
                        lineWidth: 3.0,
                      ),
                    )
                  : SizedBox.shrink(),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.grey,
                        backgroundImage: _displayProfileImage(),
                      ),
                      FlatButton(
                        onPressed: _handleImageFromGallery,
                        child: Text(
                          'Change Profile Image',
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                        ),
                      ),
                      TextFormField(
                        initialValue: _name,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            size: 30.0,
                          ),
                          labelText: 'Name',
                        ),
                        validator: (input) => input.trim().length < 1
                            ? 'Please enter a valid name'
                            : null,
                        onSaved: (input) => _name = input,
                      ),
                      TextFormField(
                        initialValue: _bio,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.book,
                            size: 30.0,
                          ),
                          labelText: 'Bio',
                        ),
                        validator: (input) => input.trim().length > 150
                            ? 'Please enter a bio less than 150 characters'
                            : null,
                        onSaved: (input) => _bio = input,
                        maxLines: 4,
                      ),
                      TextFormField(
                        initialValue: _email,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            size: 30.0,
                          ),
                          labelText: 'Email',
                        ),
                        validator: (input) => !input.contains('@')
                            ? 'Please enter a valid email address'
                            : null,
                        onSaved: (input) => _email = input,
                      ),
                      TextFormField(
                        initialValue: _phoneNumber,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.contact_phone_rounded,
                            size: 30.0,
                          ),
                          labelText: 'Phone Number',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (input) => input.contains('*')
                            ? 'Please enter a valid phoneNumber'
                            : null,
                        onSaved: (input) => _phoneNumber = input,
                      ),
                      SizedBox(height: 25.0),
                      TextFormField(
                        initialValue: _age,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          labelText: 'Age',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (input) => input.contains('*')
                            ? 'Please enter a valid Age'
                            : null,
                        onSaved: (input) => _age = input,
                      ),
                      SizedBox(height: 25.0),
                      Column(
                        children: [
                          Container(
                            child: Text(
                              "Gender : " + _gender,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          _genderRadio(_gender, _handleRadioValueChanged),
                        ],
                      ),
                      TextFormField(
                        initialValue: _address,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.location_city_rounded,
                            size: 30.0,
                          ),
                          labelText: 'Address',
                        ),
                        onSaved: (input) => _address = input,
                        maxLines: 2,
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
                            'Save Profile',
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

  _genderRadio(String groupValue, handleRadioValueChanged) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Radio(
                value: 'Male',
                groupValue: groupValue,
                onChanged: handleRadioValueChanged,
              ),
              Text(
                "Male",
                style: new TextStyle(
                  fontSize: 14.0,
                ),
              ),
              Radio(
                value: 'Female',
                groupValue: groupValue,
                onChanged: handleRadioValueChanged,
              ),
              Text(
                "Female",
                style: new TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio(
                value: 'Others',
                groupValue: groupValue,
                onChanged: handleRadioValueChanged,
              ),
              Text(
                "Others",
                style: new TextStyle(
                  fontSize: 14.0,
                ),
              ),
              Radio(
                value: 'Prefer not to say',
                groupValue: groupValue,
                onChanged: handleRadioValueChanged,
              ),
              Text(
                "Prefer not to say",
                style: new TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ],
      );

  void _handleRadioValueChanged(String value) {
    setState(() {
      this._gender = value;
    });
  }
}
