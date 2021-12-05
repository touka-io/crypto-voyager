{-# LANGUAGE OverloadedStrings #-}

module Tailwind.DataSource.CoinGecko (fetchTickers) where

import qualified Network.Wreq as W
import Optics
import Protolude
import Tailwind.Parser.CoinGecko (parseChart)
import Tailwind.Types (Ticker)

fetchTickers :: IO [Ticker]
fetchTickers = do
  resp <- W.asValue =<< W.getWith opts "https://www.coingecko.com/price_charts/solana/jpy/custom.json"
  let tickers = parseChart $ resp ^. lensVL W.responseBody
  maybe undefined pure tickers
  where
    opts = W.defaults
      & lensVL (W.param "from") .~ ["1586444400"]
      & lensVL (W.param "to") .~ ["1586530800"]
