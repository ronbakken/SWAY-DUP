/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:inf_server_explore/elasticsearch.dart';
import 'package:pedantic/pedantic.dart';
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;

import 'package:inf_common/inf_backend.dart';

class BackendExploreService extends BackendExploreServiceBase {
  final ConfigData config;
  final Elasticsearch elasticsearch;
  static final Logger opsLog = Logger('InfOps.BackendExploreService');
  static final Logger devLog = Logger('InfDev.BackendExploreService');

  final HttpClient _httpClient = HttpClient();

  BackendExploreService(this.config, this.elasticsearch);

  @override
  Future<GetOfferResponse> getOffer(grpc.ServiceCall call, GetOfferRequest request) {
    throw grpc.GrpcError.unimplemented();
  }

  @override
  Future<GetProfileResponse> getProfile(grpc.ServiceCall call, GetProfileRequest request) {
    throw grpc.GrpcError.unimplemented();
  }

  @override
  Future<InsertOfferResponse> insertOffer(grpc.ServiceCall call, InsertOfferRequest request) {
    throw grpc.GrpcError.unimplemented();
  }

  @override
  Future<InsertProfileResponse> insertProfile(grpc.ServiceCall call, InsertProfileRequest request) {
    throw grpc.GrpcError.unimplemented();
  }

  @override
  Future<ListOffersFromSenderResponse> listOffersFromSender(grpc.ServiceCall call, ListOffersFromSenderRequest request) {
    throw grpc.GrpcError.unimplemented();
  }

  @override
  Future<UpdateOfferResponse> updateOffer(grpc.ServiceCall call, UpdateOfferRequest request) {
    throw grpc.GrpcError.unimplemented();
  }

  @override
  Future<UpdateProfileResponse> updateProfile(grpc.ServiceCall call, UpdateProfileRequest request) {
    throw grpc.GrpcError.unimplemented();
  }
}

/* end of file */
