module Main (main) where

import Protolude

import qualified Data.ByteString.Lazy as LBS
import Data.Time.Clock.POSIX
import Data.Parser
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
      json <- LBS.readFile "data/custom.json"
      let ts = parseChart . decodeUtf8 . LBS.toStrict $ json
      let t0 = ts >>= head
      t0 `shouldBe` Just (posixSecondsToUTCTime 1586491595.673, 80.6141714855674)
