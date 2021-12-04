{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Database.PostgreSQL.Simple
import Data.Time.Clock.POSIX
import Protolude
import Tailwind.DB.Queries
import Tailwind.Types

db :: ByteString
db = "postgres://postgres:password@localhost:5432/voyager?sslmode=disable"

sample :: Ticker
sample = (posixSecondsToUTCTime 1586491595.673, 80.6141714855674)

main :: IO ()
main = do
  conn <- connectPostgreSQL db
  _ <- insertTickers conn "solana" [sample]
  close conn
