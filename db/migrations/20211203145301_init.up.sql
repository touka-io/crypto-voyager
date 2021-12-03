create table coin (
  id text primary key,
  symbol text not null,
  "name" text not null,
  genesis_date date not null
);

create table coin_sync (
  id text primary key references coin,
  "cursor" timestamptz not null
);

create table coin_price (
  "time" timestamptz,
  id text references coin,
  price double precision not null,
  primary key ("time", id)
);

select create_hypertable('coin_price', 'time');
