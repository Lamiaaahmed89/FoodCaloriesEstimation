// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CloriesApi extends GetxController {
  File? imagefile;
  File? file;
  double? cal;
  bool isloding = true;

  Future<void> Cloriesapi(food, context) async {
    try {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      var header = {'X-Api-Key': 'UCEbK4ZbF2xXnxj+dTODkw==o6sHY7gveuyaXA1P'};
      var url =
          Uri.parse("https://api.api-ninjas.com/v1/nutrition?query=$food");
      http.Response response = await http.get(url, headers: header);

      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        cal = json[0]["calories"];
        print(cal);
        showDialog(
            context: Get.context!,
            builder: (context) {
              return SimpleDialog(
                contentPadding: const EdgeInsets.all(20),
                children: [Column(
                  children: [
                    Image.file(imagefile!),
                    const SizedBox(height: 10,),
                    Text("$food has $cal per 100 gm",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  ],
                )],
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
