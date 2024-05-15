# Yeh35 Blog System

domain : https://www.yeh35.com


## Docker Build
- 참고 : https://medium.com/@alistairisrael/containerizing-a-phoenix-1-6-umbrella-project-8ec03651a59c
```bash
docker build --platform linux/amd64 -t yeh35_blog .
 
SECRET_KEY_BASE={{생성된_비밀키}} # mix phx.gen.secret 
docker run -p 4000:4000 -e SECRET_KEY_BASE=$SECRET_KEY_BASE -e PHX_HOST=127.0.0.1 -e PHX_SERVER=true yeh35_blog start
```