/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:wstalk/wstalk.dart';

abstract class NetworkInternals {
  // Common
  TalkSocket get ts;

  // Profiles
  void markCachedAccountsDirty();
  DataAccount emptyAccount();
  void onProfileChanged(ChangeAction action, Int64 id);
  void profileFallbackHint(DataBusinessOffer offer);
}

/* end of file */
