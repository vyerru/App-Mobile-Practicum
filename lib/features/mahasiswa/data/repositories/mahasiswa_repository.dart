// import 'package:dio/dio.dart';
// import 'package:run/features/mahasiswa/data/models/mahasiswa_model.dart';

// class MahasiswaRepository {
//   final Dio _dio = Dio();

//   Future<List<MahasiswaModel>> getMahasiswaList() async {
//     try {
//       final response = await _dio.get('https://jsonplaceholder.typicode.com/comments');
      
//       if (response.statusCode == 200) {
//         final List<dynamic> data = response.data;
//         return data.map((json) => MahasiswaModel.fromJson(json)).toList();
//       } else {
//         throw Exception('Gagal memuat data mahasiswa: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Terjadi kesalahan Dio: $e');
//     }
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:run/features/mahasiswa/data/models/mahasiswa_model.dart'; 

// class MahasiswaRepository {
//   Future<List<MahasiswaModel>> getMahasiswaList() async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://jsonplaceholder.typicode.com/comments'),
//         headers: {'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((json) => MahasiswaModel.fromJson(json)).toList();
//       } else {
//         throw Exception('Gagal memuat data mahasiswa: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Terjadi kesalahan HTTP: $e');
//     }
//   }
// }

import 'package:run/core/network/dio_client.dart';
import 'package:run/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:dio/dio.dart';

class MahasiswaRepository {
  final DioClient _dioClient;

  MahasiswaRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  Future<List<MahasiswaModel>> getMahasiswaList() async {
    try {
      final Response response = await _dioClient.dio.get('/comments');
      final List<dynamic> data = response.data;
      return data.map((json) => MahasiswaModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(
        'Gagal memuat data mahasiswa: ${e.response?.statusCode} - ${e.message}',
      );
    }
  }
}