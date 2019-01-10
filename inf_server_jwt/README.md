# JWT Backend

Backend service dedicated to sign JWT claims, on port `8919`.
Also serves the public JSON Web KeyStore at `http://127.0.0.1:8918/.well-known/jwks.json`.

See JWT Sample in `sample_jwt` for testing.

## Generating keys

```
openssl genrsa -out private.pem 2048
openssl rsa -in private.pem -RSAPublicKey_out -out public.pem
```
