# Manually configure Datagrid



```
 sudo podman pod create --name datagrid-demo -p 11222:11222
 ```


 ```
 sudo podman run \
-d --restart=always --pod=datagrid-demo \
-v /data:/data \
-e POSTGRESQL_DATABASE="root" \
-e POSTGRESQL_USER="root" \
-e POSTGRESQL_PASSWORD="password" \
--name=postgresql registry.redhat.io/rhel8/postgresql-12
 ```

   postgres:
    image: registry.redhat.io/rhel8/postgresql-12
    restart: always
    ports:
      - "5432:5432"
    environment:
      POSTGRESQL_DATABASE: root
      POSTGRESQL_USER: root
      POSTGRESQL_PASSWORD: password
    volumes: 
        - ./docker_postgres_init.sql:/docker-entrypoint-initdb.d/docker_postgres_init.sql
    networks:
      - my-network