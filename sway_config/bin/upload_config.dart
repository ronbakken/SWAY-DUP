import 'dart:io';
import 'package:sway_common/inf_common.dart';
import 'package:dospace/dospace.dart' as dospace;

main() async {
  ConfigData serverConfig = new ConfigData();
  serverConfig
      .mergeFromBuffer(await new File("blob/config_server.bin").readAsBytes());
  var spaces = new dospace.Spaces(
    region: serverConfig.services.spacesRegion,
    accessKey: serverConfig.services.spacesKey,
    secretKey: serverConfig.services.spacesSecret,
  );
  var bucket = spaces.bucket(serverConfig.services.spacesBucket);
  String etag = await bucket.uploadFile(
      'config/config.bin',
      new File('blob/config.bin'),
      'application/octet-stream',
      dospace.Permissions.public);
  print(etag);
  String etagLocal = await bucket.uploadFile(
      'config/config.bin',
      new File('blob/config_local.bin'),
      'application/octet-stream',
      dospace.Permissions.public);
  print(etagLocal);
  await spaces.close();
}

/* end of file */
