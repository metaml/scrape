module Main where

import Data.Csv (encode)
import Scrape.Startup (startups, url)
import qualified Data.ByteString.Lazy.Char8 as B

main :: IO ()
main = do
  stups <- startups url
  B.putStrLn $ encode stups
