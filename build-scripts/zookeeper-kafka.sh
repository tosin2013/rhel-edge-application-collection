#!/bin/bash 
echo "Building ZOOKEEPER container"
ZOOKEEPER_IP=$(cat /etc/hosts | grep zookeeper | awk '{print $1}')
podman pod create --name strmizi-zookeeper -p 2180 -p 2181 --network rhel-edge  --ip ${ZOOKEEPER_IP}
podman run \
  -d  --pod=strmizi-zookeeper \
  -e LOG_DIR="/tmp/logs" \
  --name "zookeeper" \
    quay.io/strimzi/kafka:0.21.1-kafka-2.7.0 bin/zookeeper-server-start.sh config/zookeeper.properties

echo "Building KAFKA container"
KAFKA_IP=$(cat /etc/hosts | grep kafka | awk '{print $1}')
podman pod create --name strmizi-kafka -p 9092 -p 9092 --network rhel-edge  --ip ${KAFKA_IP}
export KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092 
export KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 
export KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 
podman run \
-d  --pod=strmizi-kafka \
-e LOG_DIR="/tmp/logs" \
-e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092 \
-e KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092 \
-e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
--name kafka \
  quay.io/strimzi/kafka:0.21.1-kafka-2.7.0 bin/kafka-server-start.sh config/server.properties --override listeners=${KAFKA_LISTENERS} --override advertised.listeners=${KAFKA_ADVERTISED_LISTENERS} --override zookeeper.connect=${KAFKA_ZOOKEEPER_CONNECT}

