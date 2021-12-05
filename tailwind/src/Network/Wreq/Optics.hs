module Network.Wreq.Optics (responseBody, param) where

import qualified Network.Wreq as W
import Optics
import Protolude

responseBody :: Lens (W.Response a) (W.Response b) a b
responseBody = lensVL W.responseBody

param :: Text -> Lens' W.Options [Text]
param key = lensVL $ W.param key
