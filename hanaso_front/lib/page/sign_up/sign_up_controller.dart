import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SignUpController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? _image;
  ImageProvider<Object> displayImage = AssetImage('assets/default_avatar.png'); // デフォルト画像

  Future<void> signUp(BuildContext context) async {
    String imageUrl = await uploadImage();
    var url = Uri.parse('http://localhost:4000/api/users');
    var response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({
      'username': usernameController.text,
      'password': passwordController.text,
      'profileImg': imageUrl,
    }));

    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacementNamed('/home');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User registered successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to register user')));
    }
  }

  Future<String> uploadImage() async {
    var uri = Uri.parse('http://localhost:4000/api/img/upload');
    var request = http.MultipartRequest('POST', uri);
    if (_image == null) {
      ByteData data = await rootBundle.load('assets/default_avatar.png');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      request.files.add(http.MultipartFile.fromBytes(
        'img',
        bytes,
        filename: 'default_avatar.png',
        contentType: MediaType('image', 'png'),
      ));
    } else {
      request.files.add(await http.MultipartFile.fromPath(
        'img',
        _image!.path,
        contentType: MediaType('image', 'jpeg'),
      ));
      displayImage = FileImage(_image!) as ImageProvider<Object>;
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var result = jsonDecode(responseData);
      return result['url'];
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      displayImage = FileImage(_image!) as ImageProvider<Object>;
    }
  }
}
