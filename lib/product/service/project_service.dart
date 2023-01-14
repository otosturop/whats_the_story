import 'package:dio/dio.dart';

class ProjectDioMixin {
  final String myBaseUrl = "http://whatsyourstory.massviptransfer.com/";
  final service = Dio(BaseOptions(baseUrl: 'http://whatsyourstory.massviptransfer.com/api/'));
}
