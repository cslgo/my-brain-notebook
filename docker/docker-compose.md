docker-compose up

docker-compose up -d

docker-compose stop

docker-compose down

docker-compose down --volumes

docker-compose run web env

docker-compose -f docker-compose.yml -f docker-compose.admin.yml run backup_db
