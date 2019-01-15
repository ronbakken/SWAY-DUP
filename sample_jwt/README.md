# JWT Sample

See https://jwt.io/ for more information on JSON Web Tokens

## How to run this sample

From the `sample_jwt` directory, open two command windows.

```
cd docker
docker-compose build
docker-compose up
```
```
pub run test
```

## Generating keys

From the `inf_server_jwt` directory.

```
openssl genrsa -out private.pem 2048
openssl rsa -in private.pem -RSAPublicKey_out -out public.pem
```
