{-# LANGUAGE OverloadedStrings #-}

module Tailwind.DataSource.CoinGecko (fetchTickers) where

import Data.Text
import qualified Network.Wreq as W
import qualified Network.Wreq.Optics as WO
import Optics
import Protolude
import Tailwind.Parser.CoinGecko (parseChart)
import Tailwind.Types (Ticker)

chartURL :: Text -> Text
chartURL id = "https://www.coingecko.com/price_charts/" <> id <> "/jpy/custom.json"

fetchTickers :: Text -> IO [Ticker]
fetchTickers id = do
  let url = unpack $ chartURL id
  resp <- W.asValue =<< W.getWith opts url
  let tickers = parseChart $ resp ^. WO.responseBody
  maybe undefined pure tickers
  where
    opts = W.defaults
      & WO.param "from" .~ ["1586444400"]
      & WO.param "to" .~ ["1586530800"]
