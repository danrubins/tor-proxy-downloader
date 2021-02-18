#!/bin/bash

FILENAME=$(basename $1)
echo "Downloading $1 to $PWD/$FILENAME"

echo "Find an open port"
CHECK="do while"
while [[ ! -z $CHECK ]]; do
    PORT=$(( ( RANDOM % 60000 ) + 1025 ))
    echo "Checking port $PORT"
    CHECK=$(sudo netstat -ap | grep $PORT)
done

echo "Use port $PORT for tor proxy"

echo "Create tor proxy container"
CONTAINER=$(docker run --detach --restart always -p $PORT:9050 tor-proxy)

echo "Wait for container to start: $CONTAINER"
sleep 10

if [ ! -f $1 ]; then
  curl --location --remote-name --proxy socks5h://127.0.0.1:$PORT $1
  export ec=$?
  echo "CURL return code $ec"
fi

while [ $ec -ne 0 ]; do
  LAST_POS=$(wc -c $FILENAME | awk '{print $1 }')
  echo "Previous download failed, try again in 10s at position $LAST_POS"
  sleep 10
  curl --location --remote-name --proxy socks5h://127.0.0.1:$PORT --continue-at $LAST_POS $1
  export ec=$?
  echo "CURL return code $ec"
done

echo "Remove container $CONTAINER"
docker rm -f $CONTAINER

echo "Done!"