module Scrape where

import Control.Applicative
import Text.HTML.Scalpel

url :: String
url = "https://www.seedtable.com/startups-space-tech"

data Startup = Startup { country :: String
                       , startups :: Int
                       }
               deriving (Eq, Show)

-- scrape startup pairs
sups :: String -> IO (Maybe [String])
sups url = scrapeURL url startups'
  where startups' :: Scraper String [String]
        startups' = chroots "ul" $ do
          l <- text anySelector
          pure l
    
  
