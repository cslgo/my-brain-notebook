
```shell
docker run -d \
  --name pg \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -v /opt/data/postgres:/var/lib/postgresql/data \
  postgres

docker run -it --rm  postgres psql -h localhost -U postgres

docker run -d \
  -p 5433:80 \
  --name pgadmin4 \
  -e PGADMIN_DEFAULT_EMAIL=test@123.com \
  -e PGADMIN_DEFAULT_PASSWORD=123456 \
  dpage/pgadmin4

# Database Configuration
# Get the default config
docker run -i --rm postgres cat /usr/share/postgresql/postgresql.conf.sample > my-postgres.conf

# Customize the config ...

# Run postgres with custom config
docker run -d \
  --name some-postgres \
  -v "$PWD/my-postgres.conf":/etc/postgresql/postgresql.conf \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -c 'config_file=/etc/postgresql/postgresql.conf' \
  postgres

#Set options directly on the run line
docker run -d \
  --name some-postgres \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -c shared_buffers=256MB \
  -c max_connections=200 \
  postgres


docker run -d -p 5433:80 --name pgadmin4 -e PGADMIN_DEFAULT_EMAIL=test@123.com -e PGADMIN_DEFAULT_PASSWORD=123456
  
docker run -d -p 5434:8080 --name adminer adminer

```