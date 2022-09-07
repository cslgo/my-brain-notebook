# Docker Commands

## Get Docker Tutorial

```bash
docker run --name repo alpine/git clone https://github.com/docker/getting-started.git

cd getting-started && docker build -t docker101tutorial .

docker run -d -p 80:80 --name docker-tutorial docker101tutorial

docker tag docker101tutorial {username}/docker101tutorial

docker push {username}/docker101tutorial

```

## Build an Image and Running

```bash

docker build -t getting-started .

docker run -dp 3000:3000 getting-started

```

## Removing a Container

```bash
docker ps 

docker stop <the-container-id>

docker rm <the-container-id>
# removing by adding the "force" flag
docker rm -f <the-container-id>
```

## Sharing an App

```bash
# 1. Go to Docker Hub and log in if you need to.
# 2. Click the Create Repository button.
# 3. For the repo name, use getting-started. Make sure the Visibility is Public.
# 4. Click the Create button!
# 5. You can push a new image to this repository using the CLI
# $docker login -u YOUR-USER-NAME
# $docker tag local-image:tagname new-repo:tagname
# $docker push new-repo:tagname
# login
docker login -u caojiaqing
# re-tag
docker tag getting-started:latest caojiaqing/getting-started:latest
# pushing 
docker push caojiaqing/getting-started:latest

```

## Persisting our Data

```bash
docker run -d ubuntu bash -c "shuf -i 1-10000 -n 1 -o /data.txt && tail -f /dev/null"
docker exec <container-id> cat /data.txt
# 1. Create a volume by using the docker volume create command.
docker volume create todo-db
# 2. Stop the todo app container once again
# docker ps -a
# docker stop <container-id>
# 3. Start the todo app container, but add the -v flag to specify a volume mount. 
docker run -dp 3000:3000 -v todo-db:/etc/todos getting-started

# 4. Diving into our Volume
docker volume inspect todo-db

[
    {
        "CreatedAt": "2021-11-02T07:25:57Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/todo-db/_data",
        "Name": "todo-db",
        "Options": {},
        "Scope": "local"
    }
]

```

## Starting a Dev-Mode Container

```bash
docker run -dp 3000:3000 \
    -w /app \
    -v "$(pwd):/app" \
    node:12-alpine \
    sh -c "yarn install && yarn run dev"

# -w /app - sets the "working directory" or the current directory that the command will run from
# node:12-alpine - the image to use. Note that this is the base image for our app from the Dockerfile
# watch the logs using docker logs -f <container-id>

```

## Multi-Container Apps

```bash
# 1. Create the network.
docker network create todo-app
# 2. Start a MySQL container 
docker run -d \
    --network todo-app --network-alias mysql \
    -v todo-db-mysql:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=secret \
    -e MYSQL_DATABASE=todos \
    mysql:5.7
# 3. To confirm we have the database up and running
docker exec -it <mysql-container-id> mysql -p
mysql> SHOW DATABASES;
# 4. Connecting to MySQL
# 4.1. Start a new container using the nicolaka/netshoot image. Make sure to connect it to the same network.
docker run -it --network todo-app nicolaka/netshoot
# 4.2 Inside the container, we're going to use the dig command, which is a useful DNS tool. We're going to look up the IP address for the hostname mysql.
dig mysql
# 5. Running our App with MySQL.
docker run -dp 3000:3000 \
  -w /app \
  -v "$(pwd):/app" \
  --network todo-app \
  -e MYSQL_HOST=mysql \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=secret \
  -e MYSQL_DB=todos \
  node:12-alpine \
  sh -c "yarn install && yarn run dev"

docker exec -it <mysql-container-id> mysql -p todos
mysql> use todos;
mysql> select * from todo_items;

```

## Using Docker Compose

```yaml
# docker-compose.yaml
version: "3.7"

services:
  app:
    image: node:12-alpine
    command: sh -c "yarn install && yarn run dev"
    ports:
      - 3000:3000
    working_dir: /app
    volumes:
      - ./:/app
    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root
      MYSQL_PASSWORD: secret
      MYSQL_DB: todos

  mysql:
    image: mysql:5.7
    volumes:
      - todo-db-mysql:/var/lib/mysql
    environment: 
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: todos

volumes:
  todo-db-mysql:
```

## Running our Application Stack

```bash
docker-compose up -d
docker-compose logs -f
# You'll notice that the volume was created as well as a network! By default.

```

## Image Building Best Practices

```bash
# Security Scanning
docker scan getting-started
# Use the docker image history command to see the layers in the getting-started image you created earlier in the tutorial
docker image history getting-started
docker image history --no-trunc getting-started
#

```

## Layer Caching

```dockerfile
FROM node:12-alpine
WORKDIR /app
# Update the Dockerfile to copy in the package.json first, install dependencies, and then copy everything else in.
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . .
CMD ["node", "src/index.js"]
```

## Multi-Stage Builds

Maven/Tomcat Example

```dockerfile
FROM maven AS build
WORKDIR /app
COPY . .
RUN mvn package

FROM tomcat
COPY --from=build /app/target/file.war /usr/local/tomcat/webapps

```

In this example, we use one stage (called build) to perform the actual Java build using Maven. In the second stage (starting at FROM tomcat), we copy in files from the build stage. The final image is only the last stage being created (which can be overridden using the --target flag).

React Example

When building React applications, we need a Node environment to compile the JS code (typically JSX), SASS stylesheets, and more into static HTML, JS, and CSS. If we aren't doing server-side rendering, we don't even need a Node environment for our production build. Why not ship the static resources in a static nginx container?

```dockerfile
FROM node:12 AS build
WORKDIR /app
COPY package* yarn.lock ./
RUN yarn install
COPY public ./public
COPY src ./src
RUN yarn run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
```

Here, we are using a node:12 image to perform the build (maximizing layer caching) and then copying the output into an nginx container. Cool, huh?
