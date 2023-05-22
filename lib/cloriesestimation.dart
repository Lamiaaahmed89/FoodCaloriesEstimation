// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Clories extends GetxController {
  File? imagefile;
  File? file;
  double? calorie;
  double? mass;

  bool isloding = true;

  Future<void> calories(context, label) async {
    try {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      var url = Uri.parse("http://192.168.1.12:5000/calories");
      var header = {
        'Content-Type': 'multipart/form-data',
      };

      final request = http.MultipartRequest('POST', url);
      request.files.add(http.MultipartFile(
          'image', imagefile!.readAsBytes().asStream(), imagefile!.lengthSync(),
          filename: imagefile!.path.split('/').last));
      request.fields['fruit_type'] = label;
      request.headers.addAll(header);
      final response = await request.send();
      Navigator.of(context).pop();
      print(response.statusCode);

      if (response.statusCode == 200) {
        var cal = await response.stream.bytesToString();
        var jsonResponse = json.decode(cal);
        calorie = jsonResponse['calories'];
        mass = jsonResponse['mass'];
        showDialog(
            context: Get.context!,
            builder: (context) {
              return SimpleDialog(
                contentPadding: const EdgeInsets.all(20),
                children: [
                  Column(
                    children: [
                      Image.file(imagefile!),
                       const SizedBox(height: 10,),
                      Text(
                        "This $label is ${mass!.round()} gm and has ${calorie!.round()} Calories almost",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              );
            });
      }
    } catch (error) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(error.toString())],
            );
          });
    }
  }
}
