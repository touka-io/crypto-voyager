{-# LANGUAGE OverloadedStrings #-}

module Data.Parser (parseChart, Ticker) where

import Data.Aeson
import Data.Aeson.Optics
import Data.Fixed
import Data.Time
import Data.Time.Clock.POSIX
import Data.Vector
import Optics
import Protolude hiding ((%))

type Ticker = (UTCTime, Double)

parseChart :: Text -> Maybe (Vector Ticker)
parseChart x = x ^? key "stats" % _Array >>= traverse parseTicker

parseTicker :: Value -> Maybe Ticker
parseTicker v = do
  t' <- v ^? nth 0 % _Number
  let ts :: Milli = realToFrac $ t' / 1000
  let t = posixSecondsToUTCTime . realToFrac $ ts
  p <- v ^? nth 1 % _Double 
  pure (t, p)
