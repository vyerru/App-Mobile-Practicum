// import 'package:dio/dio.dart';
// import 'package:run/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';

// class MahasiswaAktifRepository {
//   final Dio _dio = Dio();

//   Future<List<MahasiswaAktifModel>> getMahasiswaAktifList() async {
//     try {
//       final response = await _dio.get('https://jsonplaceholder.typicode.com/posts');
      
//       if (response.statusCode == 200) {
//         final List<dynamic> data = response.data;
//         return data.map((json) => MahasiswaAktifModel.fromJson(json)).toList();
//       } else {
//         throw Exception('Gagal memuat data mahasiswa aktif: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Terjadi kesalahan Dio: $e');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:run/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';

class MahasiswaAktifRepository {
  Future<List<MahasiswaAktifModel>> getMahasiswaAktifList() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        
        return data.map((json) => MahasiswaAktifModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data mahasiswa aktif: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan HTTP: $e');
    }
  }
}