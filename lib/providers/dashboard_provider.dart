import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  int _mahasiswa = 120;
  int _dosen = 30;
  int _mataKuliah = 45;

  int get mahasiswa => _mahasiswa;
  int get dosen => _dosen;
  int get mataKuliah => _mataKuliah;

  void tambahMahasiswa() {
    _mahasiswa++;
    notifyListeners();
  }

  void tambahDosen() {
    _dosen++;
    notifyListeners();
  }

  void tambahMataKuliah() {
    _mataKuliah++;
    notifyListeners();
  }
}