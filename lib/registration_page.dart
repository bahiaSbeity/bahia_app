import 'package:flutter/material.dart';
import 'rugs_list_page.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _controllerFirstName = TextEditingController();
  TextEditingController _controllerLastName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  void update(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

    setState(() {
      _loading = false;
    });
  }

  Future<void> _registration(String _firstName, String _lastName, String _email, String _password) async {
    String _baseUrl = 'bahiarugs.atwebpages.com';
    final url = Uri.http(_baseUrl, 'register.php');
    try {
      final response = await http.post(
        url,
        body: {
          'firstName': _firstName,
          'lastName': _lastName,
          'email': _email,
          'password': _password,
        },
      ).timeout(Duration(seconds: 10));

      if (response.body == "true") {
        // Registration successful
        update('Registration succeeded');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RugsPage(),
          ),
        );
      } else {
        // Registration failed
        update('Registration failed, please try again.');
      }
    } catch (e) {
      update('Registration failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                controller: _controllerFirstName,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                controller: _controllerLastName,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                controller: _controllerEmail,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                controller: _controllerPassword,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _registration(_controllerFirstName.text, _controllerLastName.text, _controllerEmail.text, _controllerPassword.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}