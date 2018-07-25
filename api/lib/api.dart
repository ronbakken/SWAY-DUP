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

import 'package:api/inf.pb.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
// import 'package:postgres/postgres.dart' as postgres;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/*
devinf-api
AUGKNEZGFQVUROSP2CB7
AK8dfZ8nD+QYl6Nz662YMa2oSjrG/uUmXte8t4ojd70
*/

selfTestSql(sqljocky.ConnectionPool sql) async { // ⚠️✔️❌🛑 // Emojis make code run faster
  List<sqljocky.Row> selfTest1 = await (await sql.query('SELECT message FROM self_test WHERE self_test_id=1')).toList();
  if ("${selfTest1[0][0]}" != "Zipper Sorting 😏") {
    print('[❌] SQL Self Test: expected: "Zipper Sorting 😏", actual: "${selfTest1[0][0]}"');
    throw selfTest1[0][0];
  } else {
    print("[✔️] SQL Self Test");
  }
}

run() async {
  sqljocky.ConnectionPool sql = new sqljocky.ConnectionPool(
    host: 'mariadb.devinf.net', port: 3306,
    user: 'devinf', password: 'fCaxEcbE7YrOJ7YY',
    db: 'inf', max: 5);
  selfTestSql(sql);

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
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/* end of file */