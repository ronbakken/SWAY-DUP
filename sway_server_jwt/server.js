/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

// HTTP server
var http = require('http');

// Load up protobuf package
var PROTO_PATH = __dirname + '/backend_jwt.proto';
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
var inf = grpc.loadPackageDefinition(packageDefinition).inf;
console.log(inf);

// Load up private key and generate jwk
var fs = require('fs');
var rsaPemToJwk = require('rsa-pem-to-jwk');
var pem = fs.readFileSync('private.pem');
var jwk = rsaPemToJwk(pem, { use: 'sig' }, 'public');
var jwks = JSON.stringify({ keys: [jwk] }, null, 4);
fs.writeFileSync('jwks_public.json', jwks);
console.log('JWK:');
console.log(jwk);
var jwt = require('jsonwebtoken');

jwt.sign({
    'iss': 'https://sway-dev.net',
    'aud': 'sway-dev',
}, pem, { algorithm: 'RS256' }, function (err, token) {
    console.log('Application Token:');
    console.log(err || token);
});

// iat: NumericDate
// exp: NumericDate
function sign(call, callback) {
    // console.log('Call:');
    // console.log(call);
    var claim;
    try {
        claim = JSON.parse(call.request.claim);
    } catch (error) {
        console.log(error);
        // TODO: gRPC error?
        return callback('Failed to parse claim.');
    }
    // console.log('Claim:');
    // console.log(claim);
    return jwt.sign(claim, pem, { algorithm: 'RS256' }, function (err, token) {
        // console.log('Signed Token: ' + (err || token));
        // TODO: gRPC error?
        return callback(err && 'Failed to sign claim.', { token: token });
    });
}

function getKeyStore(call, callback) {
    // console.log(call);
    return callback(null, { jwks: jwks });
}

function main() {
    var server = new grpc.Server();
    server.addService(inf.BackendJwt.service, { sign: sign, getKeyStore: getKeyStore });
    server.bind('0.0.0.0:8929', grpc.ServerCredentials.createInsecure());
    server.start();

    http.createServer(function (req, res) {
        console.log(req.url);
        // http://127.0.0.1:8928/.well-known/jwks.json
        if (req.url == '/.well-known/jwks.json') {
            res.write(jwks);
        }
        res.end();
    }).listen(8928);
}

main();

/* end of file */
