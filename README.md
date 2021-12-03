# Crypto Voyager

A new Age of Discovery is coming. Sail out!

## Development

### Prepare the DB

```
$ podman run -d --name timescaledb -p 5432:5432 -e POSTGRES_PASSWORD=password timescale/timescaledb:latest-pg14
$ podman exec timescaledb psql -U postgres -w -c "create database voyager;"
```

### DB migration

[migrate](https://github.com/golang-migrate/migrate)

```
$ export POSTGRESQL_URL='postgres://postgres:password@localhost:5432/voyager?sslmode=disable'
$ migrate create -ext sql -dir db/migrations create_users_table
$ migrate -database ${POSTGRESQL_URL} -path db/migrations up
```
