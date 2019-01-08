/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:convert';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:geohash/geohash.dart';
import 'package:inf_common/inf_common.dart';
import 'package:s2geometry/s2geometry.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:http_client/console.dart' as http_client;
import 'package:grpc/grpc.dart' as grpc;
import 'package:pedantic/pedantic.dart';

Future<DataLocation> getGeoIPLocation(
    ConfigData config, http_client.Client httpClient, String ipAddress) async {
  DataLocation location = DataLocation();
  // location.name = ''; // User name
  // location.avatarUrl = ''; // View of the establishment

  // Fetch info
  http_client.Request request = http_client.Request(
      'GET',
      config.services.ipstackApi +
          '/' +
          Uri.encodeComponent(ipAddress) +
          '?access_key=' +
          config.services.ipstackKey);
  http_client.Response response = await httpClient.send(request);
  BytesBuilder builder = BytesBuilder(copy: false);
  await response.body.forEach(builder.add);
  String body = utf8.decode(builder.toBytes());
  if (response.statusCode != 200) {
    throw Exception(response.reasonPhrase);
  }
  dynamic doc = json.decode(body);
  if (doc['latitude'] == null || doc['longitude'] == null) {
    throw Exception("No GeoIP information for '$ipAddress'");
  }
  if (doc['country_code'] == null) {
    throw Exception("GeoIP information for '$ipAddress' not in a country");
  }

  // Not very localized, but works for US
  String approximate =
      ''; // "${doc['city']}, ${doc['region_name']} ${doc['zip']}";
  if (doc['city'] != null && doc['city'] != 'Singapore') {
    approximate = doc['city'];
  }
  if (doc['region_name'] != null) {
    if (approximate.length > 0) {
      approximate = approximate + ', ';
    }
    approximate = approximate + doc['region_name'];
    if (doc['zip'] != null) {
      approximate = approximate + ' ' + doc['zip'];
    }
  }
  if (approximate.length == 0 || doc['country_code'].toLowerCase() != 'us') {
    if (doc['country_name'] != null) {
      if (approximate.length > 0) {
        approximate = approximate + ', ';
      }
      approximate = approximate + doc['country_name'];
    }
  }
  if (approximate.length == 0) {
    throw Exception("Insufficient GeoIP information for '$ipAddress'");
  }
  location.approximate = approximate;
  location.detail = approximate;
  if (doc['zip'] != null) location.postcode = doc['zip'];
  if (doc['region_code'] != null)
    location.regionCode = doc['region_code'];
  else
    location.regionCode = doc['country_code'].toLowerCase();
  location.countryCode = doc['country_code'].toLowerCase();
  location.latitude = doc['latitude'];
  location.longitude = doc['longitude'];
  location.s2cellId = Int64(new S2CellId.fromLatLng(
          S2LatLng.fromDegrees(location.latitude, location.longitude))
      .id);
  location.geohash =
      Geohash.encode(location.latitude, location.longitude, codeLength: 20);
  return location;
}

Future<DataLocation> getGeocodingFromGPS(ConfigData config,
    http_client.Client httpClient, double latitude, double longitude) async {
  // /geocoding/v5/{mode}/{longitude},{latitude}.json
  // /geocoding/v5/{mode}/{query}.json
  String url = "${config.services.mapboxApi}/geocoding/v5/"
      "mapbox.places/$longitude,$latitude.json?"
      "access_token=${config.services.mapboxToken}";

  // Fetch info
  http_client.Request request = http_client.Request('GET', url);
  http_client.Response response = await httpClient.send(request);
  BytesBuilder builder = BytesBuilder(copy: false);
  await response.body.forEach(builder.add);
  String body = utf8.decode(builder.toBytes());
  if (response.statusCode != 200) {
    throw Exception(response.reasonPhrase);
  }
  dynamic doc = json.decode(body);
  if (doc['query'] == null ||
      doc['query'][0] == null ||
      doc['query'][1] == null) {
    throw Exception("No geocoding information for '$longitude,$latitude'");
  }
  dynamic features = doc['features'];
  if (features == null || features.length == 0) {
    throw Exception("No geocoding features at '$longitude,$latitude'");
  }

  // detailed place_type may be:
  // - address
  // for user search, may get detailed place as well from:
  // - poi.landmark
  // - poi
  // approximate place_type may be:
  // - neighborhood (downtown)
  // - (postcode (los angeles, not as user friendly) (skip))
  // - place (los angeles)
  // - region (california)
  // - country (us)
  // get the name from place_name
  // strip ", country text" (under context->id starting with country, text)
  // don't let the user change approximate address, just the detail one
  dynamic featureDetail;
  dynamic featureApproximate;
  dynamic featureRegion;
  dynamic featurePostcode;
  dynamic featureCountry;
  // List<String>().any((String v) => [ "address", "poi.landmark", "poi" ].contains(v));
  for (dynamic feature in features) {
    dynamic placeType = feature['place_type'];
    if (featureDetail == null &&
        placeType.any((dynamic v) =>
            const ["address", "poi.landmark", "poi"].contains(v.toString()))) {
      featureDetail = feature;
    } else if (featureApproximate == null &&
        placeType.any((dynamic v) => const ["locality", "neighborhood", "place"]
            .contains(v.toString()))) {
      featureApproximate = feature;
    } else if (featureRegion == null &&
        placeType.any((dynamic v) => const ["region"].contains(v.toString()))) {
      featureRegion = feature;
    } else if (featurePostcode == null &&
        placeType
            .any((dynamic v) => const ["postcode"].contains(v.toString()))) {
      featurePostcode = feature;
    } else if (featureCountry == null &&
        placeType
            .any((dynamic v) => const ["country"].contains(v.toString()))) {
      featureCountry = feature;
    }
  }
  if (featureCountry == null) {
    throw Exception("Geocoding not in a country at '$longitude,$latitude'");
  }
  if (featureRegion == null) {
    featureRegion = featureCountry;
  }
  if (featureApproximate == null) {
    featureApproximate = featureRegion;
  }
  if (featureDetail == null) {
    featureDetail = featureApproximate;
  }

  // Entry
  final String country = featureCountry['text'];
  final DataLocation location = DataLocation();
  location.approximate =
      featureApproximate['place_name'].replaceAll(', United States', '');
  location.detail =
      featureDetail['place_name'].replaceAll(', United States', '');
  if (featurePostcode != null) {
    location.postcode = featurePostcode['text'];
  }
  final String regionCode = featureRegion['properties']['short_code'];
  if (regionCode != null) {
    location.regionCode = regionCode;
  }
  final String countryCode = featureCountry['properties']['short_code'];
  if (countryCode != null) {
    location.countryCode = countryCode;
  }
  location.latitude = latitude;
  location.longitude = longitude;
  location.s2cellId = Int64(new S2CellId.fromLatLng(
          S2LatLng.fromDegrees(location.latitude, location.longitude))
      .id);
  location.geohash =
      Geohash.encode(location.latitude, location.longitude, codeLength: 20);
  return location;
}

Future<DataLocation> getGeocodingFromName(
    ConfigData config, http_client.Client httpClient, String name) async {
  // /geocoding/v5/{mode}/{longitude},{latitude}.json
  // /geocoding/v5/{mode}/{query}.json
  String url = "${config.services.mapboxApi}/geocoding/v5/"
      "mapbox.places/${Uri.encodeComponent(name)}.json?"
      "access_token=${config.services.mapboxToken}";

  // Fetch info
  http_client.Request request = http_client.Request('GET', url);
  http_client.Response response = await httpClient.send(request);
  BytesBuilder builder = BytesBuilder(copy: false);
  await response.body.forEach(builder.add);
  String body = utf8.decode(builder.toBytes());
  if (response.statusCode != 200) {
    throw Exception(response.reasonPhrase);
  }
  dynamic doc = json.decode(body);
  if (doc['query'] == null ||
      doc['query'][0] == null ||
      doc['query'][1] == null) {
    throw Exception("No geocoding information for '$name'");
  }
  dynamic features = doc['features'];
  if (features == null || features.length == 0) {
    throw Exception("No geocoding features at '$name'");
  }

  // detailed place_type may be:
  // - address
  // for user search, may get detailed place as well from:
  // - poi.landmark
  // - poi
  // approximate place_type may be:
  // - neighborhood (downtown)
  // - (postcode (los angeles, not as user friendly) (skip))
  // - place (los angeles)
  // - region (california)
  // - country (us)
  // get the name from place_name
  // strip ", country text" (under context->id starting with country, text)
  // don't let the user change approximate address, just the detail one
  dynamic featureDetail;
  dynamic featureApproximate;
  dynamic featureRegion;
  dynamic featurePostcode;
  dynamic featureCountry;
  // List<String>().any((String v) => [ "address", "poi.landmark", "poi" ].contains(v));
  for (dynamic feature in features) {
    dynamic placeType = feature['place_type'];
    if (featureDetail == null &&
        placeType.any((dynamic v) =>
            const ["address", "poi.landmark", "poi"].contains(v.toString()))) {
      featureDetail = feature;
    } else if (featureApproximate == null &&
        placeType.any((dynamic v) => const ["locality", "neighborhood", "place"]
            .contains(v.toString()))) {
      featureApproximate = feature;
    } else if (featureRegion == null &&
        placeType.any((dynamic v) => const ["region"].contains(v.toString()))) {
      featureRegion = feature;
    } else if (featurePostcode == null &&
        placeType
            .any((dynamic v) => const ["postcode"].contains(v.toString()))) {
      featurePostcode = feature;
    } else if (featureCountry == null &&
        placeType
            .any((dynamic v) => const ["country"].contains(v.toString()))) {
      featureCountry = feature;
    }
  }

  if (featureApproximate == null) {
    featureApproximate = featureRegion;
  }
  featureDetail = featureApproximate; // Override

  if (featureDetail == null) {
    throw Exception("No approximate geocoding found at '$name'");
  }

  dynamic contextPostcode;
  dynamic contextRegion;
  dynamic contextCountry;
  if (featureCountry == null) {
    for (dynamic context in featureDetail['context']) {
      if (contextPostcode == null &&
          context['id'].toString().startsWith('postcode.')) {
        contextPostcode = context;
      } else if (contextCountry == null &&
          context['id'].toString().startsWith('country.')) {
        contextCountry = context;
      } else if (contextRegion == null &&
          context['id'].toString().startsWith('region.')) {
        contextRegion = context;
      }
    }
  }

  if (contextRegion == null) {
    contextRegion = contextCountry;
  }

  if (contextCountry == null && featureCountry == null) {
    throw Exception("Geocoding not in a country at '$name'");
  }

  // Entry
  String country =
      featureCountry == null ? contextCountry['text'] : featureCountry['text'];
  DataLocation location = DataLocation();
  location.approximate =
      featureApproximate['place_name'].replaceAll(', United States', '');
  location.detail =
      featureDetail['place_name'].replaceAll(', United States', '');
  if (contextPostcode != null)
    location.postcode = contextPostcode['text'];
  else if (featurePostcode != null) location.postcode = featurePostcode['text'];

  final String regionCode = featureRegion == null
      ? contextRegion['short_code']
      : featureRegion['properties']['short_code'];
  if (regionCode != null) {
    location.regionCode = regionCode;
  }
  final String countryCode = featureCountry == null
      ? contextCountry['short_code']
      : featureCountry['properties']['short_code'];
  if (countryCode != null) {
    location.countryCode = countryCode;
  }
  location.latitude = featureDetail['center'][1];
  location.longitude = featureDetail['center'][0];
  location.s2cellId = Int64(S2CellId.fromLatLng(
          S2LatLng.fromDegrees(location.latitude, location.longitude))
      .id);
  location.geohash =
      Geohash.encode(location.latitude, location.longitude, codeLength: 20);
  return location;
}

/*

Example GeoJSON:

{
  "ip": "49.145.22.242",
  "type": "ipv4",
  "continent_code": "AS",
  "continent_name": "Asia",
  "country_code": "PH",
  "country_name": "Philippines",
  "region_code": "05",
  "region_name": "Bicol",
  "city": "Lagonoy",
  "zip": "4425",
  "latitude": 13.7386,
  "longitude": 123.5206,
  "location": {
    "geoname_id": 1708078,
    "capital": "Manila",
    "languages": [
      {
        "code": "en",
        "name": "English",
        "native": "English"
      }
    ],
    "country_flag": "http://assets.ipstack.com/flags/ph.svg",
    "country_flag_emoji": "🇵🇭",
    "country_flag_emoji_unicode": "U+1F1F5 U+1F1ED",
    "calling_code": "63",
    "is_eu": false
  }
}


*/

/* end of file */
