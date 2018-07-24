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

run() async {
  sqljocky.ConnectionPool pool = new sqljocky.ConnectionPool(
    host: 'mariadb.devinf.net', port: 3306,
    user: 'devinf', password: 'fCaxEcbE7YrOJ7YY',
    db: 'inf', max: 5);
  var results = await pool.query('SELECT name FROM business_accounts');
  results.forEach((row) async {
    print('Name: ${row[0]}');
    
    var results2 = await pool.query('SELECT name FROM business_accounts');
    results2.forEach((row) {
      print('Name: ${row[0]}');
    });
    
  });
  
  /*
  var connection = new postgres.PostgreSQLConnection("localhost", 5432, "dart_test", username: "dart", password: "dart");
  await connection.open();
  */
}

//void prepareRequest(String filePath, int size) {
  /*
  PUT /example.txt HTTP/1.1
  
  Content-Length: 14
  Content-Type: text/plain
  Host: static-images.nyc3.digitaloceanspaces.com
  x-amz-content-sha256: 003f0e5fe338b17be8be93fec537764ce199ac50f4e50f2685a753c4cc781747
  x-amz-date: 20170710T194605Z
  x-amz-meta-s3cmd-attrs:uid:1000/gname:asb/uname:asb/gid:1000/mode:33204/mtime:1499727909/atime:1499727909/md5:fb08934ef619f205f272b0adfd6c018c/ctime:1499713540
  x-amz-storage-class: STANDARD
  Authorization: AWS4-HMAC-SHA256 Credential=II5JDQBAN3JYM4DNEB6C/20170710/nyc3/s3/aws4_request,SignedHeaders=content-length;content-type;host;x-amz-content-sha256;x-amz-date;x-amz-meta-s3cmd-attrs;x-amz-storage-class,Signature=a9a9e16da23e0b37ae8362824de77d66bba2edd702ee5f291f6ecbb9ebac6013
  
  Example text.
  
  x-amz-acl 	A "canned" ACL specifying access rules for the object (e.g. private or public-read). If not set, defaults to private.
  */
  /*
  Example Authorization Header
  
  Authorization: AWS4-HMAC-SHA256
  Credential=II5JDQBAN3JYM4DNEB6C/20170710/nyc3/s3/aws4_request,
  SignedHeaders=host;x-amz-acl;x-amz-content-sha256;x-amz-date,
  Signature=6cab03bef74a80a0441ab7fd33c829a2cdb46bba07e82da518cdb78ac238fda5
  
  Signing Example (psuedo-code)
  
  canonicalRequest = `
  ${HTTPMethod}\n
  ${canonicalURI}\n
  ${canonicalQueryString}\n
  ${canonicalHeaders}\n
  ${signedHeaders}\n
  ${hashedPayload}
  `
  
  stringToSign = "AWS4-HMAC-SHA256" + "\n" +
    date(format=ISO08601) + "\n" +
    date(format=YYYYMMDD) + "/" + ${REGION} + "/" + "s3/aws4_request" + "\n" +
    Hex(SHA256Hash(canonicalRequest))

  dateKey = HMAC-SHA256("AWS4" + ${SECRET_KEY}, date(format=YYYYMMDD))
  dateRegionKey = HMAC-SHA256(dateKey, ${REGION})
  dateRegionServiceKey = HMAC-SHA256(dateRegionKey, "s3")
  signingKey = HMAC-SHA256(dateRegionServiceKey, "aws4_request")
  
  signature = Hex(HMAC-SHA256(signingKey, stringToSign))
  

  */
//}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/* end of file */