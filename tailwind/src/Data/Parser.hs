{-# LANGUAGE OverloadedStrings #-}

module Data.Parser (parseChart, Ticker) where

import Data.Aeson
import Data.Aeson.Optics
import Data.Fixed
import Data.Time.Clock.POSIX
import Optics
import Protolude hiding ((%))
import Tailwind.Types

parseChart :: Value -> Maybe [Ticker]
parseChart x = x ^? key "stats" % _Array >>= traverse parseTicker . toList

parseTicker :: Value -> Maybe Ticker
parseTicker v = do
  t' <- v ^? nth 0 % _Number
  let ts :: Milli = realToFrac $ t' / 1000
  let t = posixSecondsToUTCTime . realToFrac $ ts
  p <- v ^? nth 1 % _Double 
  pure (t, p)
