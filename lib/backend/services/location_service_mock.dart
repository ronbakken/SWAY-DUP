import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:inf/backend/services/location_service_.dart';
import 'package:rxdart/rxdart.dart';

class LocationServiceMock implements LocationService {
  final Coordinate _lastLocation = Coordinate(34.047259, -118.324178);

  @override
  Stream<Coordinate> get onLocationChanged => _onLocationChangedSubject;

  final BehaviorSubject<Coordinate> _onLocationChangedSubject =
      new BehaviorSubject<Coordinate>();

  LocationServiceMock() {
    _onLocationChangedSubject.add(_lastLocation);
  }

  final http.Client client = http.Client();

  Future<MapboxResponse> lookupMapBoxPlaces(Coordinate nearby, String text) async {
    var searchText = Uri.encodeComponent(text.replaceAll(';', ','));
    var nearbyString = nearby!=null ? '&proximity=${nearby.longitude},${nearby.latitude}' : '';

    var url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$searchText.json?types=address,place,poi'
        '$nearbyString'
        '&access_token=pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqa2pkOThmdzFha2IzcG16aHl4M3drNTcifQ.jtaEoGuiomNgllDjUMCwNQ';

    final response = await client.get(url);
    if (response.statusCode == 200) {
      return MapboxResponse.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<MapboxResponse> lookupMapBoxCoordinates(Coordinate position, [bool onlyAdresses = false]) async {

    var url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${position.longitude},${position.latitude}.json?types=${onlyAdresses ? 'adress': 'address,place,poi'}'
        '&access_token=pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqa2pkOThmdzFha2IzcG16aHl4M3drNTcifQ.jtaEoGuiomNgllDjUMCwNQ';

    final response = await client.get(url);
    if (response.statusCode == 200) {
      return MapboxResponse.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }



  @override
  Coordinate get lastLocation => _lastLocation;

  @override
  Future<List<GeoCodingResult>> lookUpPlaces({Coordinate nearby, String searchText}) async {
    var response = await lookupMapBoxPlaces(nearby, searchText);
    var results = <GeoCodingResult>[];
    if (response != null)
    {
        for(var feature in response.features)
        {
            results.add(GeoCodingResult(Coordinate(feature.center[1],feature.center[0]), feature.placeName));
        }
        
    }
    return results;
  }

  List<GeoCodingResult> lastCoordinateLookUpResult;
  Coordinate lastCoodinateLookUpPosition;

  @override
  Future<List<GeoCodingResult>> lookUpCoordinates({Coordinate position, bool onlyAdresses = false}) async {

    if (lastCoodinateLookUpPosition == position && lastCoordinateLookUpResult != null)
    {
      return lastCoordinateLookUpResult;
    }

    var response = await lookupMapBoxCoordinates(position, onlyAdresses);
    var results = <GeoCodingResult>[];
    if (response != null)
    {
        for(var feature in response.features)
        {
            results.add(GeoCodingResult(Coordinate(feature.center[1],feature.center[0]), feature.placeName));
        }
        
    }
    lastCoodinateLookUpPosition = position;
    lastCoordinateLookUpResult =results;
    return results;
  }
}

class MapboxResponse {
  String type;
  List<String> query;
  List<Features> features;

  MapboxResponse({this.type, this.query, this.features});

  MapboxResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    query = json['query'].cast<String>();
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features.add(new Features.fromJson(v));
      });
    }
  }
}

class Features {
  String id;
  String type;
  List<String> placeType;
  double relevance;
  //Properties properties;
  String text;
  String placeName;
  //List<double> bbox;
  List<double> center;
  //Geometry geometry;
  //List<Context> context;

  Features({
    this.id,
    this.type,
    this.placeType,
    this.relevance,
    // this.properties,
    this.text,
    this.placeName,
    // this.bbox,
    this.center,
    // this.geometry,
    // this.context
  });

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    placeType = json['place_type'].cast<String>();
    if (json['relevance'] is int) {
      relevance = (json['relevance'] as int).toDouble();
    } else {
      relevance = json['relevance'];
    }
    // properties = json['properties'] != null
    //     ? new Properties.fromJson(json['properties'])
    //     : null;
    text = json['text'];
    placeName = json['place_name'];
    center = json['center'].cast<double>();
  }
}

// class Properties {
//   String wikidata;

//   Properties({this.wikidata});

//   Properties.fromJson(Map<String, dynamic> json) {
//     wikidata = json['wikidata'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['wikidata'] = this.wikidata;
//     return data;
//   }
// }

// class Geometry {
//   String type;
//   List<double> coordinates;

//   Geometry({this.type, this.coordinates});

//   Geometry.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     coordinates = json['coordinates'].cast<double>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['type'] = this.type;
//     data['coordinates'] = this.coordinates;
//     return data;
//   }
// }

// class Context {
//   String id;
//   String shortCode;
//   String wikidata;
//   String text;

//   Context({this.id, this.shortCode, this.wikidata, this.text});

//   Context.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     shortCode = json['short_code'];
//     wikidata = json['wikidata'];
//     text = json['text'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['short_code'] = this.shortCode;
//     data['wikidata'] = this.wikidata;
//     data['text'] = this.text;
//     return data;
//   }
// }
