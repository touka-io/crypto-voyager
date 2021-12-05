module Main (main) where

import Data.Aeson
import qualified Data.ByteString.Lazy as LBS
import Data.Time.Clock.POSIX
import Protolude
import Tailwind.Parser.CoinGecko
import Test.Tasty
import Test.Tasty.Hspec
import Test.Hspec

main :: IO ()
main = do
  tree <- testSpec "hspec tests" spec
  defaultMain tree

spec :: Spec
spec = do
  describe "parse chart data" $
    it "pending" $ do
      text <- LBS.readFile "data/custom.json"
      let ts = decode text >>= parseChart
      let t0 = ts >>= head
      t0 `shouldBe` Just (posixSecondsToUTCTime 1586491595.673, 80.6141714855674)
