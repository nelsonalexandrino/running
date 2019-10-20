import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/athlete.dart';

class Registrations with ChangeNotifier {
  final _headers = {'Content-Type': 'application/json'};

  Athlete _athlete;

  Athlete get getCurrentAthlete {
    return _athlete;
  }

  Future<void> registerAthlete(Athlete athlete) async {
    final url = 'http://3.15.196.43/api/users';

    var body = {
      'name': athlete.name,
      'email': athlete.email,
      'telefone': athlete.phone,
      'bi': athlete.idNumber,
      'nacionalidade': athlete.nationality,
      'quilometragem': athlete.mileage.contains('21') ? '21' : '5',
      'data_nascimento': DateFormat('yyyy-MM-dd').format(athlete.birthday),
      'sexo': athlete.gender.toLowerCase().contains('masculino') ? 'M' : 'F',
    };

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(body),
      );

      Map<dynamic, dynamic> data = json.decode(response.body);
      if (data.containsKey('error')) {
        throw data['error'];
      }
      final preferences = await SharedPreferences.getInstance();
      preferences.setString('athlete', json.encode(body));

      if (response.statusCode == 200) {
        _athlete = athlete;
      }

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> getLocalAthlete() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('athlete')) {
      return false;
    }

    final extratedAthleteData =
        json.decode(preferences.getString('athlete')) as Map<String, Object>;

    _athlete = Athlete(
      name: extratedAthleteData['name'],
      email: extratedAthleteData['email'],
      phone: extratedAthleteData['telefone'],
      idNumber: extratedAthleteData['bi'],
      nationality: extratedAthleteData['nacionalidade'],
      mileage: extratedAthleteData['quilometragem'],
      birthday: DateFormat('yyyy-MM-dd')
          .parse(extratedAthleteData['data_nascimento']),
      gender: extratedAthleteData['sexo'],
    );

    return true;
  }
}
