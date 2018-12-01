import 'dart:io';
import 'package:inf_common/inf_common.dart';
import 'package:dospace/dospace.dart' as dospace;
import 'package:http_client/console.dart' as http;

main() async {
  ConfigData serverConfig = new ConfigData();
  serverConfig
      .mergeFromBuffer(await new File("config/config_server.bin").readAsBytes());
  var spaces = new dospace.Spaces(
    region: serverConfig.services.spacesRegion,
    accessKey: serverConfig.services.spacesKey,
    secretKey: serverConfig.services.spacesSecret,
    httpClient: new http.ConsoleClient()
  );
  var bucket = spaces.bucket(serverConfig.services.spacesBucket);
  String etag = await bucket.uploadFile('config/config.bin', 'config/config.bin',
      'application/octet-stream', dospace.Permissions.public);
  print(etag);
  await spaces.close();
}

/* end of file */
