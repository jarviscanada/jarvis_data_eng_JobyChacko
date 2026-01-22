#!/bin/sh

# Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

# Start docker
sudo systemctl status docker > /dev/null 2>&1 || sudo systemctl start docker

# Check container status
docker container inspect jrvs-psql
container_status=$?
echo "DEBUG: cmd=$cmd"
echo "DEBUG: container_status=$container_status"
echo "DEBUG: args_count=$# user=$db_username pass=$db_password"
case $cmd in 
  create)
  if [ $container_status -eq 0 ]; then
		echo 'Container already exists'
		exit 1	
	fi

  if [ $# -ne 3 ]; then
    echo 'Create requires username and password'
    exit 1
  fi
  
  # Create container
	docker volume create pgdata
  # Start the container
  echo "Running docker run..."
	docker run --name jrvs-psql -e POSTGRES_USER=$db_username -e POSTGRES_PASSWORD=$db_password  -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine
	exit $?
	;;

  start|stop) 

  if [ $container_status -ne 0 ]; then
    echo 'Container does not exist'
    exit 1
  fi

  # Start or stop the container
	docker container $cmd jrvs-psql
	exit $?
	;;	
  
  *)
	echo 'Illegal command'
	echo 'Commands: start|stop|create'
	exit 1
	;;
esac 
