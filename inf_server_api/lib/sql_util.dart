/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

class SqlUtil {
  static String makeInsertQuery(String table, List<String> columns) {
    final StringBuffer buffer = StringBuffer();
    buffer.write('INSERT INTO `$table`(');
    buffer
        .write(columns.map<String>((String column) => '`$column`').join(', '));
    buffer.write(') VALUES (');
    buffer.write(columns.map<String>((String _) => '?').join(', '));
    buffer.write(')');
    return buffer.toString();
  }

  static String makeSelectQuery(String table, List<String> columns) {
    final StringBuffer buffer = StringBuffer();
    buffer.write('SELECT ');
    buffer
        .write(columns.map<String>((String column) => '`$column`').join(', '));
    buffer.write('FROM `$table`');
    return buffer.toString();
  }
}

/* end of file */
