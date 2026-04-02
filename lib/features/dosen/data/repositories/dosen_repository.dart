// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:run/features/dosen/data/models/dosen_model.dart'; // Sesuaikan dengan nama package Anda

// class DosenRepository {
//   /// Mendapatkan daftar dosen
//   Future<List<DosenModel>> getDosenList() async {
//     final response = await http.get(
//       Uri.parse('https://jsonplaceholder.typicode.com/users'),
//       headers: {'Accept': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       print(data); // Debug: Tampilkan data yang sudah di-decode
//       return data.map((json) => DosenModel.fromJson(json)).toList();
//     } else {
//       print('Error: ${response.statusCode} ${response.body}');
//       throw Exception('Gagal memuat data dosen: ${response.statusCode}');
//     }
//   }
// }

// import 'package:dio/dio.dart';
// import 'package:run/features/dosen/data/models/dosen_model.dart';

// class DosenRepository {
//   final Dio _dio = Dio();

//   /// Mendapatkan daftar dosen menggunakan Dio
//   Future<List<DosenModel>> getDosenList() async {
//     try {
//       final response = await _dio.get('https://jsonplaceholder.typicode.com/users');
      
//       if (response.statusCode == 200) {
//         final List<dynamic> data = response.data;
//         return data.map((json) => DosenModel.fromJson(json)).toList();
//       } else {
//         throw Exception('Gagal memuat data dosen: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Terjadi kesalahan: $e');
//     }
//   }
// }

import 'package:run/core/network/dio_client.dart';
import 'package:run/features/dosen/data/models/dosen_model.dart';
import 'package:dio/dio.dart';

class DosenRepository {
  final DioClient _dioClient;

  DosenRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  /// Mendapatkan daftar dosen dari API
  Future<List<DosenModel>> getDosenList() async {
    try {
      final Response response = await _dioClient.dio.get('/users');
      final List<dynamic> data = response.data;
      return data.map((json) => DosenModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(
        'Gagal memuat data dosen: ${e.response?.statusCode} - ${e.message}',
      );
    }
  }
}