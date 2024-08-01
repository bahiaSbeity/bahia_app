import 'package:flutter/material.dart';
import 'rugs_list_page.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_code/registration_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controllerUsername = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  void update(String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

    setState(() {
      _loading = false;
    });
  }

  Future<void> _login(String _username, String _password) async {
    String _baseUrl = 'bahiarugs.atwebpages.com';
    final url = Uri.http(_baseUrl, 'login.php');

    try {
      final response = await http.post(
        url,

        body: {
            'email': _username,
            'password': _password,
          },
      ).timeout(Duration(seconds: 10));

      if (response.body == "true") {
        // Login successful
        update('Login succeeded');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RugsPage(),
          ),
        );
      } else {
        // Login failed
        update('Login failed, incorrect credentials.');
      }
    } catch (e) {
      update('Login failed: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                controller: _controllerUsername
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
                  controller: _controllerPassword

              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _login(_controllerUsername.text, _controllerPassword.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Login'),
              ),
              SizedBox(height: 16.0),
              // Link to login page
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                child: Text(
                  'Register Now',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
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