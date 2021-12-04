{-# LANGUAGE QuasiQuotes #-}

module Tailwind.DB.Queries (insertTickers) where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.SqlQQ
import Protolude
import Tailwind.Types

insertCoinPrices :: Query
insertCoinPrices =
  [sql| insert into coin_price
        values (?, ?, ?)
  |]

insertTickers :: Connection -> Text -> [Ticker] -> IO Int64
insertTickers conn id tickers =
  executeMany conn insertCoinPrices values
  where
    values = (\(t, p) -> (t, id, p)) <$> tickers
