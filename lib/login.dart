import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class sign extends StatefulWidget {
  const sign({super.key});

  @override
  State<sign> createState() => _signState();
}

class _signState extends State<sign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
        Center(
          child: SizedBox(
            width: 300,
            height: 500,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Text('Sign up',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  Gap(150),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email'
                    ),
                  ),
                  Gap(10),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ],),
              ),
            ),
          ),
        ),
      ],),
    );
  }
}