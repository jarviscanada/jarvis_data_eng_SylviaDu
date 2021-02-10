#!/bin/bash

# commands
job=$1
db_username=$2
db_password=$3
container_name='jrvs-psql'

# start docker if not already running
systemctl status docker || systemctl start docker

# determine the command passed into script
case $job in
  create)
    # print error message if
    if [ "$#" -lt 3 ]; then
      echo "Illegal number of parameters for 'create'"
      exit 1
    fi
    # raise error if container already exists
    container_num=$(($(docker container ls -a -f name="$container_name" | wc -l)-1))
    if [ $container_num -eq 1 ]; then
      echo "The container is already created"
      exit 0
    fi
    # create container with username and password
    docker volume create pgdata
    docker run --name "$container_name" -e POSTGRES_USER="$db_username" \
    -e POSTGRES_PASSWORD="$db_password" -d -v \
    pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
    exit $?
    ;;

  start)
    docker container start "$container_name"
    exit $?
    ;;

  stop)
    docker container stop "$container_name"
    exit $?
    ;;

  *)
    echo "Invalid parameter"
    exit 1
    ;;
esac

exit 0