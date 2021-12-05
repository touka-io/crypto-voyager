{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Database.PostgreSQL.Simple
import Protolude
import Tailwind.DataSource.CoinGecko
import Tailwind.DB.Queries

db :: ByteString
db = "postgres://postgres:password@localhost:5432/voyager?sslmode=disable"

main :: IO ()
main = do
  conn <- connectPostgreSQL db
  ts <- fetchTickers "solana"
  putText $ "fetch_data count=" <> show (length ts)
  count <- insertTickers conn "solana" ts
  putText $ "write_db count=" <> show count
  close conn
