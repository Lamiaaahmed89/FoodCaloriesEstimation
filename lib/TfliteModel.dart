// ignore_for_file: file_names, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'cloriesapi.dart';
import 'cloriesestimation.dart';

class TfliteModel extends StatefulWidget {
  const TfliteModel({Key? key}) : super(key: key);

  @override
  _TfliteModelState createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {
  CloriesApi controller = Get.put(CloriesApi());
  Clories controller2 = Get.put(Clories());

  late File _image;
  late List<dynamic> _results = [];
  bool imageSelect = false;
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
        model: "assets/My_TFlite_Model.tflite", labels: "assets/labels.txt"))!;
    print("Models loading status: $res");
  }

  Future imageClassification(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results = recognitions!;
      print(_results);
      _image = image;
      imageSelect = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 106,180,185),
        title: const Text("Food Calories Estimation"),
      ),
      body: ListView(
        children: [
          (imageSelect)
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: const Image(
                              image: AssetImage(
                                  "assets/_e5e42a3f-a5e1-4e13-b9a9-d0aca781a2e4.jpg"),width: 250,height: 250,)
                )
              : Container(
                  margin: const EdgeInsets.all(10),
                  child: Opacity(
                      opacity: 0.8,
                      child: Container(
                          margin: const EdgeInsets.all(10),
                          child: const Image(
                              image: AssetImage(
                                  "assets/2eceab28fbd4c2fcb0c184d0eef57784.jpg"),width: 250,height: 250))),
                ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(255, 106,180,185),),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(1, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      controller.Cloriesapi(_results[0]['label'], context);
                    },
                    child: const Text("Calories per 100 gm")),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all<Color>(const Color.fromARGB(255, 106,180,185),),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(1, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      controller2.calories(context, _results[0]['label']);
                    },
                    child: const Text("Calories per estimated Mass")),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 106,180,185),
        onPressed: pickImage,
        tooltip: "Pick Image",
        child: const Icon(Icons.image),
      ),
    );
  }

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image = File(pickedFile!.path);
    controller2.imagefile = image;
    controller.imagefile = image;
    imageClassification(image);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
