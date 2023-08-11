import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vinyl_rental/globals.dart';
import 'package:vinyl_rental/vinyl_list.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text('Wypożyczalnia płyt winylowych'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Logowanie',
                    style: normal,
                  ),
                  SizedBox(
                    height: space * 2,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Colors.blueGrey.shade300), //<-- SEE HERE
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Colors.blueGrey.shade500), //<-- SEE HERE
                      ),
                      labelStyle: MaterialStateTextStyle.resolveWith(
                          (states) => TextStyle(color: getColor(states))),
                      labelText: 'Email',
                      hintStyle: MaterialStateTextStyle.resolveWith(
                          (states) => TextStyle(color: getColor(states))),
                    ),
                    onChanged: (value) => email = value,
                  ),
                  SizedBox(
                    height: space,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Colors.blueGrey.shade300), //<-- SEE HERE
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3,
                            color: Colors.blueGrey.shade500), //<-- SEE HERE
                      ),
                      labelStyle: MaterialStateTextStyle.resolveWith(
                          (states) => TextStyle(color: getColor(states))),
                      labelText: 'Hasło',
                      hintStyle: MaterialStateTextStyle.resolveWith(
                          (states) => TextStyle(color: getColor(states))),
                    ),
                    onChanged: (value) => password = value,
                  ),
                  SizedBox(
                    height: space,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.resolveWith(getColor),
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                    ),
                    onPressed: () {

                      FirebaseAuth.instance.pluginConstants["disableWarnings"] = true;
                      FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
                      FirebaseAuth.instance .signInWithEmailAndPassword(
                          email: email,
                          password: password
                      ).then((value) {

                        currentUser = FirebaseAuth.instance.currentUser!.displayName;

                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => VinylList()));

                      }).catchError(
                              (error) => print(error)
                      );



                          /* if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }*/


                    },
                    child: Text('Zaloguj'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
