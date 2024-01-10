module Scrape.Startup where

import Data.Csv (FromRecord, ToRecord) 
import Data.List.Extra (dropEnd, splitOn, trim)
import Data.Maybe (fromMaybe)
import GHC.Generics
import Text.HTML.Scalpel

data Startup = Startup { location :: String
                       , startups :: Int
                       }
             deriving (Eq, Generic, Show, ToRecord, FromRecord)

url :: String
url = "https://www.seedtable.com/startups-space-tech"

startups :: URL -> IO [Startup]
startups u = do
  ps <- startupPairs u
  pure $ uncurry Startup <$> ps

startupPairs :: URL -> IO [(String, Int)]
startupPairs u = do
  ps <- startupPairs' u
  pure $ fromMaybe [] ps
  
-- scrape startup pairs
startupPairs' :: URL -> IO (Maybe [(String, Int)])
startupPairs' u = scrapeURL u sups
  where sups :: Scraper String [(String, Int)]
        sups = chroot ("section" @: [hasClass "cities-bar"]) geos

        geos :: Scraper String [(String, Int)]
        geos = chroot "ul" cities

        cities :: Scraper String [(String, Int)]
        cities = chroots "li" city

        city :: Scraper String (String, Int)
        city = chroot "a" pair

        pair :: Scraper String (String, Int)
        pair = do
          s <- text anySelector
          let p = splitOn "(" . dropEnd 1 . trim $ s
          pure (trim(p!!0), read (p!!1) :: Int)
