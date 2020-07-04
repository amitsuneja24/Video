import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class apiService{
  Future postVideo(File file) async{
    final uri= Uri.parse('https://upload-vid.herokuapp.com/upload');
    var request = http.MultipartRequest('POST', uri)
    ..files.add(await http.MultipartFile.fromPath('video',file.path,contentType: MediaType('video','mp4') ));
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Uploaded!');
      return 'Uploaded';
    }

    
}}


//  var request = http.MultipartRequest('POST', uri)
//    ..fields['user'] = 'nweiz@google.com'
//    ..files.add(await http.MultipartFile.fromPath(
//        'package', 'build/package.tar.gz',
//        contentType: MediaType('application', 'x-tar')));
//  var response = await request.send();
//  if (response.statusCode == 200) print('Uploaded!');