/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:convert';
import 'dart:core';

import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart' as http;
import 'package:inf_common/inf_common.dart';
import 'package:logging/logging.dart';

class Elasticsearch {
  static final Logger opsLog = new Logger('InfOps.Elasticsearch');
  static final Logger devLog = new Logger('InfDev.Elasticsearch');

  final http.Client httpClient = new http.Client();
  final ConfigData config;
  final Map<String, String> headers;

  Elasticsearch(this.config)
      : headers = config.services.hasElasticsearchBasicAuth()
            ? <String, String>{
                "Authorization": "Basic " +
                    base64.encode(
                        utf8.encode(config.services.elasticsearchBasicAuth)),
                "Content-Type": "application/json"
              }
            : <String, String>{"Content-Type": "application/json"};

  Future<void> close() async {
    await httpClient.close();
  }

  Future<dynamic> postDocument(String index, dynamic doc) async {
    String url = config.services.elasticsearchApi + "/$index/_doc";
    devLog.finest(url);
    http.Response response = await http.post(url,
        headers: headers, body: (doc is String) ? doc : json.encode(doc));
    devLog.finest(response.body);
    if (response.statusCode < 200 && response.statusCode >= 300) {
      throw new Exception("Status Code: ${response.statusCode}, Body: ${response.body}");
    }
    return json.decode(response.body);
  }

  Future<dynamic> putDocument(String index, String id, dynamic doc) async {
    Map<String, String> headers = <String, String>{};
    String url = config.services.elasticsearchApi + "/$index/_doc/$id";
    devLog.finest(url);
    http.Response response = await http.put(url,
        headers: headers, body: (doc is String) ? doc : json.encode(doc));
    devLog.finest(response.body);
    if (response.statusCode < 200 && response.statusCode >= 300) {
      throw new Exception("Status Code: ${response.statusCode}, Body: ${response.body}");
    }
    return json.decode(response.body);
  }
}

/* end of file */
