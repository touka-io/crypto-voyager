{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import qualified Data.Text as T
import Data.Time.Clock
import Database.PostgreSQL.Simple
import Protolude
import Tailwind.DataSource.CoinGecko
import Tailwind.DB.Queries

db :: ByteString
db = "postgres://postgres:password@localhost:5432/voyager?sslmode=disable"

interval :: NominalDiffTime
interval = nominalDay * 28

main :: IO ()
main = do
  [id'] <- getArgs
  let id = T.pack id'
  conn <- connectPostgreSQL db
  forever $ do
    t <- readSyncCursor conn id
    putText $ "sync_cursor t=" <> show t
    -- TODO: Create sync cursor when not exists
    let start = fromMaybe undefined t
    let end' = addUTCTime interval start
    now <- getCurrentTime
    let today = UTCTime (utctDay now) 0
    -- TODO: Exit when end' == today
    let end = if end' > today then today else end'
    putText $ "next_range start=" <> show start <> " end=" <> show end
    ts <- fetchTickers id (start, end)
    putText $ "fetch_data count=" <> show (length ts)
    count <- insertTickers conn id ts
    putText $ "write_db count=" <> show count
    count' <- updateSyncCursor conn id end
    putText $ "save_cursor count=" <> show count'
    threadDelay 10_000_000
  -- close conn
