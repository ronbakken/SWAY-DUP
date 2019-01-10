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
var kty = jwk.kty;

// iat: NumericDate
// exp: NumericDate
function sign(call, callback) {
    console.log(call);
    // return callback(null, { message: 'Hello ' + call.request.name });
    var claim;
    try {
        claim = JSON.parse(call.claim);
    } catch (error) {
        // TODO: Fix insecure error propagation
        return callback(error);
    }
    return jwt.sign(claim, pem, { algorithm: kty }, function (err, token) {
        console.log('Signed Token:');
        console.log(token);
        // TODO: Fix insecure error propagation
        return callback(err, { token: token });
    });
}

function getKeyStore(call, callback) {
    console.log(call);
    return callback(null, { jwks: jwks });
}

function main() {
    var server = new grpc.Server();
    server.addService(inf.BackendJwt.service, { sign: sign, getKeyStore: getKeyStore });
    server.bind('0.0.0.0:8919', grpc.ServerCredentials.createInsecure());
    server.start();

    http.createServer(function (req, res) {
        console.log(req.url);
        // http://127.0.0.1:8918/.well-known/jwks.json
        if (req.url == '/.well-known/jwks.json') {
            res.write(jwks);
        }
        res.end();
    }).listen(8918);
}

main();

/* end of file */
