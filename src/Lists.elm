module Lists exposing (..)

import Form exposing (..)

-- MEASUREMENTS
measurements : List String
measurements =
  [ "teaspoon"
  , "tablespoon"
  , "cup"
  , "ounce"
  , "pint"
  , "quart"
  , "gallon"
  , "pound"
  , "pinch"
  , "fluid ounce"
  , "litre"
  , "millilitre"
  , "gram"
  , "milligram"
  , "kilogram"
  , "amount"
  ]

-- AMOUNTS
validAmounts : List String
validAmounts =
  let
    concatenate str = case str of
                                    "" -> betweenZeroAndOne
                                    _ -> List.map ((++) str) prefixedBetweenZeroAndOne
  in
    List.foldr (\s acc  -> (concatenate s) ++ acc) [] ([""] ++ integerAmounts)

prefix : String -> String
prefix s = case s of
                  "" -> ""
                  _  -> case List.member s ["half"] of
                            True -> " and a " ++ s
                            _ -> " and " ++ s

prefixedBetweenZeroAndOne = List.map (prefix) betweenZeroAndOne

integerAmounts : List String
integerAmounts = List.foldr (\s acc  -> (appendToList s) ++ acc) [] multiplesOfTen

appendToList str = case str of
                                 "" -> oneToNine ++ tenToNineteen
                                 _ -> [str] ++ List.map ((++) (str ++ " ")) oneToNine

oneToNine : List String
oneToNine =
  [ "one"
  , "two"
  , "three"
  , "four"
  , "five"
  , "six"
  , "seven"
  , "eight"
  , "nine"
  ]

tenToNineteen : List String
tenToNineteen =
  [ "ten"
  , "eleven"
  , "twelve"
  , "thirteen"
  , "fourteen"
  , "fifteen"
  , "sixteen"
  , "seventeen"
  , "eighteen"
  , "nineteen"
  ]

multiplesOfTen : List String
multiplesOfTen =
  [ ""
  , "twenty"
  , "thirty"
  , "fourty"
  , "fifty"
  , "sixty"
  , "seventy"
  , "eighty"
  , "ninety"
  , "one hundred"
  ]

betweenZeroAndOne : List String
betweenZeroAndOne =
  [ ""
  , "one eighth"
  , "one quarter"
  , "three eighths"
  , "one half"
  , "half"
  , "five eighths"
  , "three quarters"
  , "seven eighths"
  ]
