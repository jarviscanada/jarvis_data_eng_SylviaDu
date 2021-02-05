#!/bin/bash

# arguments
job=$1
db_username=$2
db_password=$3

# start docker if not already running
systemctl status docker || systemctl start docker

# check number of arguments: at least 1
if [ "$#" -eq 0 ]; then
  echo "Illegal number of parameters"
  exit 1
fi

# determine the command passed into script
case $job in
  create)
    # print error message if
    if [ "$#" -lt 3 ]; then
      echo "Illegal number of parameters for 'create'"
      exit 1
    fi
    # raise error if container already exists
    container_num=$(($(docker container ls -a -f name=jrvs-psql | wc -l)-1))
    if [ $container_num -eq 1 ]; then
      echo "The container is already created"
      exit 1
    fi
    # create container with username and password
    docker volume create pgdata
    docker run --name jrvs-psql -e POSTGRES_USER=$db_username \
    -e POSTGRES_PASSWORD=$db_password -d -v \
    pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
    exit $?
    ;;

  start)
    docker container start jrvs-psql
    exit $?
    ;;

  stop)
    docker container stop jrvs-psql
    exit $?
    ;;

  *)
    echo "Invalid parameter"
    exit 1
    ;;
esac

exit 0