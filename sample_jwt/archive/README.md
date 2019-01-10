# JWT Sample

See https://jwt.io/ for more information on JSON Web Tokens

## How to run this sample

```
cd docker
docker-compose build
docker-compose up
```
```
pub run tests
```

## Generating keys

```
openssl genrsa -out private.pem 2048
openssl rsa -in private.pem -RSAPublicKey_out -out public.pem
```
