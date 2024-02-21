# Yeh35 Blog System

domain : https://www.yeh35.com


## Docker Build

```bash
docker build --platform linux/amd64 -t yeh35_blog .

SECRET_KEY_BASE=woD+Ok8GKOov7IloKZL94HTLYwv4tOhjS1hkg//yi7IcgNZbjfAr62R4wTXBXb+T
docker run -p 4000:4000 -e SECRET_KEY_BASE=$SECRET_KEY_BASE -e PHX_HOST=127.0.0.1 -e PHX_SERVER=true yeh35_blog start
```