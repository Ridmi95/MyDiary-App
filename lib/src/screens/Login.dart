import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mydiary/src/screens/root_app.dart';
import 'package:mydiary/src/theme/colors.dart';
import 'HomePage.dart';
import 'SignUp.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _email, _password;

  //check authentification and navigate to HomePage
  checkAuthentification() async {
    // _auth.onAuthStateChanged.listen((user) {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RootApp()));
      }
    });
    @override
    void initState() {
      super.initState();
      this.checkAuthentification();
    }
  }

  login() async {
    print('login');
    if (_formKey.currentState!.validate()) {
      print('if inside');
      _formKey.currentState!.save();

      try {
        print('try inside');
        // FirebaseUser user = await _auth.signInWithEmailAndPassword(email: _email, password: _password);
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        checkAuthentification();
      } catch (e) {
        print('catch inside');
        showError("The password is invalid or the user does not have a password");
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  navigateToSignUp() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 277,
              child: Image(
                image: AssetImage("images/login.jpg"),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextFormField(
                          // ignore: missing_return
                          validator: (input) {
                            if (input!.isEmpty) return 'Enter Email';
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Colors.black,
                          ),
                              prefixIcon: Icon(Icons.email)),
                          onSaved: (input) => _email = input!),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: TextFormField(

                          // ignore: missing_return
                          validator: (input) {
                            if (input!.length < 6)
                              return 'Provide Minium 6 Character';
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          onSaved: (input) => _password = input!),
                    ),
                    SizedBox(height: 40),
                    RaisedButton(
                        padding: EdgeInsets.fromLTRB(90, 10, 90, 10),
                        onPressed: login,
                        child: Text('LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: primary)
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text('Create an Account? Sign Up',
                  style: TextStyle(
                      color: primary,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold)),
              onTap: navigateToSignUp,
            )
          ],
        ),
      ),
    );
  }
}
