import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  
  //-----------------------------------------

  final _formkey = GlobalKey<FormState> ();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  //-----------------------------------------

  startauthentication() {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(validity) {
      _formkey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential usercredential;  //AuthResult authresult;
    try{
      if(isLoginPage){
        usercredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      }
      else{
        usercredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        String uid = usercredential.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username':username,
          'email':email
        });
      }
    }
    catch(err){
      print(err);
      
    }
  }


  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(!isLoginPage)
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  key: ValueKey('username'),
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Invalid Username';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _username = value!;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide()),
                    labelText: "Username",
                    labelStyle: GoogleFonts.roboto()),
                ),
                SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                key: ValueKey('email'),
                validator: (value) {
                  if(value!.isEmpty || !value.contains('@')){
                    return 'Invalid Email';
                  }
                  return null;
                },
                onSaved: (value){
                  _email = value!;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide()),
                  labelText: "Email",
                  labelStyle: GoogleFonts.roboto()),
              ),
              SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                key: ValueKey('password'),
                validator: (value) {
                  if(value!.isEmpty){
                    return 'Invalid Password';
                  }
                  return null;
                },
                onSaved: (value){
                  _password = value!;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide()),
                  labelText: "Password",
                  labelStyle: GoogleFonts.roboto()),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                height: 70,
                child: ElevatedButton( 
                  onPressed: () {
                    startauthentication();
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    )
                  ),    
                  child: isLoginPage
                    ? Text('Login',
                    style: GoogleFonts.roboto(fontSize: 16),)
                    : Text('Sign Up',
                    style: GoogleFonts.roboto(fontSize: 16),)         
              ),),
              SizedBox(height: 10),
              Container(
                child: TextButton(
                  onPressed: (){
                    setState(() {
                      isLoginPage = !isLoginPage;
                    });
                  },
                  child: isLoginPage
                    ? Text('Not a member? Sign Up')
                    : Text('Already a member?')
                ),
              )
          ]),)
        )
      ]),
    );
  }
}