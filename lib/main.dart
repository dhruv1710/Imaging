import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imageai/constants.dart';
import 'package:imageai/loading.dart';
import 'package:imageai/login.dart';
import 'package:share_plus/share_plus.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImageIO.ai',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const sign(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isLoading = false;
  Uint8List? image = null;
  late TextEditingController _controller;
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }


  Future<void> _getImage(text) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        "https://api.stability.ai/v1/generation/stable-diffusion-xl-1024-v1-0/text-to-image");

  print('${Constants.stabilityKey}');
    // Make the HTTP POST request to the Stability Platform API
    final response = await http.post(
      url,  
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Constants.stabilityKey}',
        'Accept': 'image/png',
      },
      body: jsonEncode({
        'seed':0,
        'cfg_scale': 5,
        'height': 1024,
        'width': 1024,
        'samples': 1,
        'steps': 50,
        'text_prompts': [
          {
            'text': _controller.text ?? '',
            'weight': 1,
          }
        ],
      }),
    );
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode != 200) {
      _showErrorDialog('Failed to generate image');
    } else {
      try {
        var _imageData = (response.bodyBytes);
        setState(() {
          image = _imageData;
        });
        
      } on Exception catch (e) {
        _showErrorDialog('Failed to generate image');
      }
    }
    return;
  }
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.primary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            //
            // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
            // action in the IDE, or press "p" in the console), to see the
            // wireframe for each widget.
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Type the prompt you imagine',
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) async {
                    Loading(context);
                    await _getImage(value);
                    Navigator.of(context).pop();
                  },
                ),
              ),image == null?Container():
              SizedBox(height:500,width:500,child: Image.memory(image??Uint8List(0))),
              image == null
                ? Container()
                : ElevatedButton(onPressed: () {Share.shareXFiles([XFile.fromData(image??Uint8List(0))],text:'Image made using Imageio.ai');},child:Text('Share'))
           ],
          ),
        ),
      
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
