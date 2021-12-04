module Tailwind.Types (Ticker) where

import Data.Time
import Protolude

type Ticker = (UTCTime, Double)
