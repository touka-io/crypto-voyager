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
  let id = "solana"
  t <- readSyncCursor conn id
  putText $ "sync_cursor t=" <> show t
  -- TODO: Create sync cursor when not exists
  let start = fromMaybe undefined t
  let end = addUTCTime interval start
  putText $ "next_range start=" <> show start <> " end=" <> show end
  ts <- fetchTickers id (start, end)
  putText $ "fetch_data count=" <> show (length ts)
  count <- insertTickers conn id ts
  putText $ "write_db count=" <> show count
  count' <- updateSyncCursor conn id end
  putText $ "save_cursor count=" <> show count'
  close conn
