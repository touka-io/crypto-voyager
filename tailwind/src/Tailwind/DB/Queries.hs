{-# LANGUAGE QuasiQuotes #-}

module Tailwind.DB.Queries (
  insertTickers, 
  readSyncCursor,
  updateSyncCursor,
) where

import Data.Time.Clock
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.SqlQQ
import Protolude
import Tailwind.Types

insertCoinPrices :: Query
insertCoinPrices =
  [sql| insert into coin_price
        values (?, ?, ?)
        on conflict do nothing
  |]

insertTickers :: Connection -> Text -> [Ticker] -> IO Int64
insertTickers conn id tickers =
  executeMany conn insertCoinPrices values
  where
    values = (\(t, p) -> (t, id, p)) <$> tickers

readSyncCursor :: Connection -> Text -> IO (Maybe UTCTime)
readSyncCursor conn id = do
  r :: [Only UTCTime] <- query conn q (Only id)
  pure $ fromOnly <$> head r
  where
    q = [sql| select cursor
              from coin_sync
              where id = ?
        |]

updateSyncCursor :: Connection -> Text -> UTCTime -> IO Int64
updateSyncCursor conn id cursor =
  execute conn q (cursor, id)
  where
    q = [sql| update coin_sync
              set cursor = ?
              where id = ?
        |]
