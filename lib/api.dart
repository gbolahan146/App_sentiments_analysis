import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIService {
  static const _apiKey = '726f021332msh360e4e38416860bp16ef2djsn0afa029e1774';
  static const String _baseUrl =
      'https://twinword-emotion-analysis-v1.p.rapidapi.com/analyze/';
  static const Map<String, String> _headers = {
    'content-type': 'application/x-www-form-urlencoded',
    'x-rapidapi-host': 'twinword-emotion-analysis-v1.p.rapidapi.com',
    'x-rapidapi-key': _apiKey,
    'useQueryString': 'true',
  };

  Future<SentAna> post({@required Map<String, String> query}) async {
    final response = await http.post(_baseUrl, headers: _headers, body: query);
    if (response.statusCode == 200) {
      print('success' + response.body);
      return SentAna.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load json data, Check internet or restart App');
    }
  }
}

class SentAna {
  final String emotions;

  SentAna({this.emotions});

  factory SentAna.fromJson(Map<String, dynamic> json) {
    return SentAna(emotions: json['emotions_detected'][0]);
  }
}
