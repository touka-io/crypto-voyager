{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Data.Time.Clock
import Database.PostgreSQL.Simple
import Protolude
import Tailwind.DataSource.CoinGecko
import Tailwind.DB.Queries

db :: ByteString
db = "postgres://postgres:password@localhost:5432/voyager?sslmode=disable"

interval :: NominalDiffTime
interval = nominalDay

main :: IO ()
main = do
  conn <- connectPostgreSQL db
  t <- readSyncCursor conn "solana"
  putText $ "sync_cursor t=" <> show t
  let start = fromMaybe undefined t
  let end = addUTCTime interval start
  putText $ "next_range start=" <> show start <> " end=" <> show end
  ts <- fetchTickers "solana" (start, end)
  putText $ "fetch_data count=" <> show (length ts)
  count <- insertTickers conn "solana" ts
  putText $ "write_db count=" <> show count
  close conn
