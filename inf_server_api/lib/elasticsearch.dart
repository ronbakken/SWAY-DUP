/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:inf_common/inf_common.dart';
import 'package:logging/logging.dart';

class Elasticsearch {
  static final Logger opsLog = Logger('InfOps.Elasticsearch');
  static final Logger devLog = Logger('InfDev.Elasticsearch');

  final http.Client httpClient = http.Client();
  final ConfigData config;
  final Map<String, String> headers;
  final String endPoint;

  static Map<String, String> _buildHeaders(ConfigData config) {
    final String platformElasticsearch =
        Platform.environment['INF_ELASTICSEARCH'];
    if (platformElasticsearch != null) {
      final String platformBasicAuth =
          Platform.environment['INF_ELASTICSEARCH_BASIC_AUTH'];
      return platformBasicAuth != null
          ? <String, String>{
              'Authorization':
                  'Basic ' + base64.encode(utf8.encode(platformBasicAuth)),
              'Content-Type': 'application/json'
            }
          : <String, String>{'Content-Type': 'application/json'};
    } else {
      return config.services.hasElasticsearchBasicAuth()
          ? <String, String>{
              'Authorization': 'Basic ' +
                  base64.encode(
                      utf8.encode(config.services.elasticsearchBasicAuth)),
              'Content-Type': 'application/json'
            }
          : <String, String>{'Content-Type': 'application/json'};
    }
  }

  static String _getEndPoint(ConfigData config) {
    return Platform.environment['INF_ELASTICSEARCH'] ??
        config.services.elasticsearchApi;
  }

  Elasticsearch(this.config)
      : headers = _buildHeaders(config),
        endPoint = _getEndPoint(config);

  Future<void> close() async {
    httpClient.close();
  }

  Future<dynamic> postDocument(String index, dynamic doc) async {
    final String url = endPoint + '/$index/_doc';
    devLog.finest(url);
    final http.Response response = await httpClient.post(url,
        headers: headers, body: (doc is String) ? doc : json.encode(doc));
    devLog.finest(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Status Code: ${response.statusCode}, Request Headers: $headers, Response Body: ${response.body}');
    }
    return json.decode(response.body);
  }

  Future<dynamic> putDocument(String index, String id, dynamic doc) async {
    final String url = endPoint + '/$index/_doc/$id';
    devLog.finest(url);
    final http.Response response = await httpClient.put(url,
        headers: headers, body: (doc is String) ? doc : json.encode(doc));
    devLog.finest(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Status Code: ${response.statusCode}, Request Headers: $headers, Response Body: ${response.body}');
    }
    return json.decode(response.body);
  }

  Future<dynamic> getDocument(String index, String id) async {
    final String url = endPoint + '/$index/_doc/$id';
    devLog.finest(url);
    final http.Response response = await httpClient.get(url, headers: headers);
    devLog.finest(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Status Code: ${response.statusCode}, Request Headers: $headers, Response Body: ${response.body}');
    }
    final dynamic res = json.decode(response.body);
    if (!res['found']) {
      throw Exception('Document not found.');
    }
    return res['_source'];
  }

  Future<dynamic> search(String index, dynamic search) async {
    final String url = endPoint + '/$index/_search';
    devLog.finest(url);
    final http.Request request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(headers);
    request.body = (search is String) ? search : json.encode(search);
    final http.StreamedResponse response = await httpClient.send(request);
    final String body = await utf8.decodeStream(response.stream);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Status Code: ${response.statusCode}, Request Headers: $headers, Response Body: $body');
    }
    final dynamic res = json.decode(body);
    return res;
  }
}

/* end of file */
