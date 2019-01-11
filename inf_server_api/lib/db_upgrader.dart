/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:core';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;

/*

Database upgrader.
This mechanism is designed to eventually succeed
if multiple services are attempting this at the same time.

*/

class _DbUpgradeFunction {
  final String tag;
  final Future<void> Function(sqljocky.QueriableConnection sql) function;

  const _DbUpgradeFunction(this.tag, this.function);
}

class DbUpgrader {
  final String _service;
  final sqljocky.ConnectionPool _sql;
  final List<_DbUpgradeFunction> _functions = <_DbUpgradeFunction>[];
  final Set<String> _tags = Set<String>();

  DbUpgrader(this._service, this._sql);

  void registerUpgrade(String tag,
      Future<void> Function(sqljocky.QueriableConnection sql) function) {
    if (_tags.contains(tag)) {
      throw Exception("Tag '$tag' already inserted.");
    }
    _functions.add(_DbUpgradeFunction(tag, function));
    _tags.add(tag);
  }

  Future<void> createSchemaTagsTable() async {
    try {
      await _sql.query(''
          'CREATE TABLE `schema_tags` ('
          '  `created` timestamp NOT NULL DEFAULT current_timestamp(),'
          '  `service` varchar(64) COLLATE latin1_general_ci NOT NULL,'
          '  `tag` varchar(64) COLLATE latin1_general_ci NOT NULL,'
          '  `success` int(11) NOT NULL DEFAULT 0'
          ') ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci');
    } catch (_, __) {}
    try {
      await _sql.query(''
          'ALTER TABLE `schema_tags`'
          '  ADD PRIMARY KEY (`tag`)');
    } catch (_, __) {}
  }

  Future<Set<String>> _listSchemaTags(sqljocky.QueriableConnection sql) async {
    const String query = 'SELECT `tag`, `success` FROM `schema_tags`';
    final sqljocky.Results results = await sql.query(query);
    final Set<String> result = Set<String>();
    await for (sqljocky.Row row in results) {
      result.add(row[0].toString());
      if (row[1].toInt() == 0) {
        throw Exception(
            "Detected unsuccessful MySQL upgrade '${row[0].toString()}', aborting to stop data loss");
      }
    }
    return result;
  }

  Future<void> run() async {
    // Check if upgrade is needed
    await createSchemaTagsTable();
    Set<String> tags = await _listSchemaTags(_sql);
    bool upgradeRequired = false;
    for (_DbUpgradeFunction function in _functions) {
      if (!tags.contains(function.tag)) {
        upgradeRequired = true;
        break;
      }
    }

    do {
      await _sql.startTransaction((sqljocky.Transaction sql) async {
        // Refresh tags from lock
        tags = await _listSchemaTags(sql);
        // Process one unprocessed tags
        upgradeRequired = false;
        for (_DbUpgradeFunction function in _functions) {
          if (!tags.contains(function.tag)) {
            upgradeRequired = true;
            await sql.prepareExecute(
                'INSERT INTO `schema_tags` (`service`, `tag`) VALUES (?, ?)',
                <dynamic>[_service, function.tag]);
            // As MySQL automatically commits transactions when modifying schemes,
            // in case of failure, the success flag will not be set.
            // The scheme tag list function causes abort when it encounters
            // an unsuccessful upgrade to stop data loss.
            await function.function(sql);
            await sql.prepareExecute(
                'UPDATE `schema_tags` SET `success` = 1 WHERE `tag` = ?;',
                <dynamic>[function.tag]);
            break;
          }
        }
      });
    } while (upgradeRequired);
  }
}

/* end of file */
