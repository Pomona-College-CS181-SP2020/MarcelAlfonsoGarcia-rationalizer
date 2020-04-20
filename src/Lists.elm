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
    prefix s = case List.member s ["three-quarters", "one half", "one quarter"] of
                      True -> " and " ++ s
                      _ -> " and a " ++ s
    prefixedBetweenZeroAndOne = List.map (prefix) betweenZeroAndOne
    concatenate str = List.map ((++) str) prefixedBetweenZeroAndOne
    rationals = List.foldr (\s acc  -> (concatenate s) ++ acc) [] integerAmounts
  in
    integerAmounts ++ rationals ++ betweenZeroAndOne

integerAmounts : List String
integerAmounts =
  let
    appendToList str = List.map ((++) (str ++ " ")) oneToNine
    inBetween = List.foldr (\s acc  -> (appendToList s) ++ acc) [] multiplesOfTen
  in
    oneToNine ++ elevenToNineteen ++ multiplesOfTen ++ inBetween

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

elevenToNineteen : List String
elevenToNineteen =
  [ "eleven"
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
  [ "ten"
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
  [ "one half"
  , "one quarter"
  , "quarter"
  , "half"
  , "three-quarters"
  ]
