/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// https://pub.dartlang.org/packages/sqljocky5
// INSERT INTO `business_accounts` (`business_id`, `name`, `home_address`, `home_gps`) VALUES (NULL, 'Kahuna Burger', 'Los Angeles', GeomFromText('POINT(0 0)'));

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
// import 'package:postgres/postgres.dart' as postgres;
import 'package:wstalk/wstalk.dart';
import 'package:dospace/dospace.dart' as dospace;

import 'inf.pb.dart';
import 'remote_app.dart';

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/*
devinf-api
AUGKNEZGFQVUROSP2CB7
AK8dfZ8nD+QYl6Nz662YMa2oSjrG/uUmXte8t4ojd70
*/

selfTestSql(sqljocky.ConnectionPool sql) async {
  // ⚠️✔️❌🛑 // Emojis make code run faster
  final Logger opsLog = new Logger('InfOps.SelfTest');
  try {
    List<sqljocky.Row> selfTest1 = await (await sql
            .query('SELECT message FROM self_test WHERE self_test_id=1'))
        .toList();
    if ("${selfTest1[0][0]}" != "Zipper Sorting 😏") {
      opsLog.severe(
          '[❌] SQL Self Test: expected: "Zipper Sorting 😏", actual: "${selfTest1[0][0]}"'); // CRITICAL - OPERATIONS
    } else {
      opsLog.info("[✔️] SQL Self Test");
    }
  } catch (ex) {
    opsLog.severe('[❌] SQL Self Test: $ex'); // CRITICAL - OPERATIONS
  }
}

selfTestTalk() async {
  final Logger opsLog = new Logger('InfOps.SelfTest');
  TalkSocket ts;
  try {
    ts = await TalkSocket.connect("ws://localhost:8090/api");
    Future<Null> listen = ts.listen();
    for (int i = 0; i < 3; ++i) {
      await ts.ping();
    }
    ts.close();
    await listen;
    opsLog.info("[✔️] WSTalk Self Test");
  } catch (ex) {
    opsLog.severe("[❌] WSTalk Self Test: $ex"); // CRITICAL - OPERATIONS
  }
  if (ts != null) {
    ts.close();
  }
}

run() async {
  // Logging
  // final Logger opsLog = new Logger('OPS');
  // final Logger devLog = new Logger('DEV');
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  new Logger('InfOps').level = Level.ALL;
  new Logger('InfDev').level = Level.ALL;
  new Logger('SqlJocky').level = Level.WARNING;
  new Logger('SqlJocky.BufferedSocket').level = Level.WARNING;

  // Server Configuration
  Uint8List configBytes =
      await new File("assets/config_server.bin").readAsBytes();
  ConfigData config = new ConfigData();
  config.mergeFromBuffer(configBytes);

  // Run SQL client
  final sqljocky.ConnectionPool sql = new sqljocky.ConnectionPool(
      host: config.services.mariadbHost,
      port: config.services.mariadbPort,
      user: config.services.mariadbUser,
      password: config.services.mariadbPassword,
      db: config.services.mariadbDatabase,
      max: 5);
  selfTestSql(sql);

  // Spaces
  final dospace.Spaces spaces = new dospace.Spaces(
    region: config.services.spacesRegion,
    accessKey: config.services.spacesKey,
    secretKey: config.services.spacesSecret,
  );
  final dospace.Bucket bucket = spaces.bucket(config.services.spacesBucket);

  // Listen to websocket
  final HttpServer server =
      await HttpServer.bind(InternetAddress.anyIPv6, 8090);
  () async {
    await for (HttpRequest request in server) {
      print(request.uri.path);
      print(request.headers);
      if (request.uri.path == '/api' || request.uri.path == '/api/') {
        // Upgrade to WSTalk socket
        TalkSocket ts;
        try {
          WebSocket ws = await WebSocketTransformer.upgrade(request);
          ts = new TalkSocket(ws);
          RemoteApp remoteApp;
          ts.stream(TalkSocket.encode("INFAPP")).listen((TalkMessage message) {
            if (remoteApp == null) {
              String ipAddress = request.connectionInfo.remoteAddress.address;
              String xRealIP = request.headers.value('x-real-ip');
              remoteApp = new RemoteApp(config, sql, bucket, ts,
                  ipAddress: xRealIP != null ? xRealIP : ipAddress);
            }
          });
          // Listen
          () async {
            try {
              await ts
                  .listen(); // Any exception will ultimately fall down to here
            } catch (ex) {
              print("Exception from remote app:");
              print(ex);
            }
            ts.close();
            if (remoteApp != null) {
              remoteApp.dispose();
              remoteApp = null;
            }
          }()
              .catchError((ex) {
            print("Exception listening to app:");
            print(ex);
          });
        } catch (ex) {
          print("Exception from incoming connection:");
          print(ex);
          ts.close();
        }
      } else {
        try {
          request.response.statusCode = HttpStatus.FORBIDDEN;
          request.response.close();
        } catch (ex) {
          print("Exception responding to invalid request:");
          print(ex);
        }
      }
    }
    print("Server exited");
  }()
      .catchError((ex) {
    print("Exception running server:");
    print(ex);
  });
  selfTestTalk();
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/*
  var results = await pool.query('SELECT name FROM business_accounts');
  results.forEach((row) async {
    print('Name: ${row[0]}');
    
    var results2 = await pool.query('SELECT name FROM business_accounts');
    results2.forEach((row) {
      print('Name: ${row[0]}');
    });
    
  });
  */

/* end of file */
