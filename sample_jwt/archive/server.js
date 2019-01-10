/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

// Load up sample_jwt protobuf package
var PROTO_PATH = __dirname + '/protos/sample_jwt.proto';
var grpc = require('grpc');
var protoLoader = require('@grpc/proto-loader');
var packageDefinition = protoLoader.loadSync(
    PROTO_PATH,
    {
        keepCase: true,
        longs: String,
        enums: String,
        defaults: true,
        oneofs: true
    }
);
var sample_jwt = grpc.loadPackageDefinition(packageDefinition).sample_jwt;
console.log(sample_jwt);

// Load up private key and generate jwk
var fs = require('fs');
var rsaPemToJwk = require('rsa-pem-to-jwk');
var pem = fs.readFileSync('./docker/private.pem');
var jwk = rsaPemToJwk(pem, { use: 'sig' }, 'public');
fs.writeFileSync('./docker/jwks_public.json', JSON.stringify({ keys: [jwk] }, null, 4));
console.log(jwk);

var jwt = require('jsonwebtoken');

// const jwksClient = require('jwks-rsa');

/*const client = jwksClient({
  strictSsl: true, // Default value
  jwksUri: 'docker/jwks_private.json'
});*/
/*
client.getSigningKey('infsb', (err, key) => {
const signingKey = key.publicKey || key.rsaPublicKey;
console.log(signingKey);
// Now I can use this to configure my Express or Hapi middleware
});*/

// iat: NumericDate
// exp: NumericDate
jwt.sign({ iss: 'https://infsandbox.app', aud: 'infsandbox', pb: {} }, pem, { algorithm: 'RS256' }, function (err, token) {
    console.log(err);
    console.log(token);
});

function generate(call, callback) {
    console.log(call);
    return callback(null, { message: 'Hello ' + call.request.name });
}

function validate(call, callback) {
    console.log(call);
    return callback(null, { message: 'Hello ' + call.request.name });
}

/* end of file */
