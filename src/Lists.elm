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
    , "dash"
    , "fluid ounce"
    , "liter"
    , "milliliter"
    , "gram"
    , "milligram"
    , "kilogram"
    ]


conversions : List ( String, String, Float )
conversions =
    [ ( "tablespoon", "teaspoon", 3.0 )
    , ( "tablespoon", "milliliter", 15.0 )
    , ( "cup", "ounce", 8.0 )
    , ( "cup", "fluid ounce", 8.0 )
    , ( "cup", "milliliter", 240.0 )
    , ( "cup", "tablespoon", 16.0 )
    , ( "liter", "milliliter", 1000.0 )
    , ( "gram", "milligram", 1000.0 )
    , ( "kilogram", "gram", 100.0 )
    , ( "ounce", "gram", 29.0 )
    , ( "ounce", "tablespoon", 2.0 )
    , ( "pound", "gram", 453.0 )
    , ( "quart", "pint", 2.0 )
    , ( "quart", "cup", 4.0 )
    , ( "quart", "ounce", 32.0 )
    , ( "quart", "milliliter", 950.0 )
    , ( "pint", "cup", 2.0 )
    , ( "pint", "ounce", 16.0 )
    , ( "pinch", "teaspoon", 0.0625 )
    , ( "dash", "teaspoon", 0.125 )
    , ( "gallon", "quart", 4.0 )
    , ( "gallon", "pint", 8.0 )
    , ( "gallon", "cup", 16.0 )
    , ( "gallon", "fluid ounce", 128.0 )
    , ( "fluid ounce", "tablespoon", 2.0 )
    , ( "fluid ounce", "teaspoon", 6.0 )
    ]



-- AMOUNTS


validAmounts : List String
validAmounts =
    let
        concatenate str =
            case str of
                "" ->
                    betweenZeroAndOne

                _ ->
                    List.map ((++) str) prefixedBetweenZeroAndOne
    in
    List.foldr (\s acc -> concatenate s ++ acc) [] ([ "" ] ++ integerAmounts)


prefix : String -> String
prefix s =
    case s of
        "" ->
            ""

        _ ->
            case List.member s [ "half" ] of
                True ->
                    " and a " ++ s

                _ ->
                    " and " ++ s


prefixedBetweenZeroAndOne =
    List.map prefix betweenZeroAndOne


integerAmounts : List String
integerAmounts =
    List.foldr (\s acc -> appendToList s ++ acc) [] multiplesOfTen


appendToList str =
    case str of
        "" ->
            oneToNine ++ tenToNineteen

        _ ->
            [ str ] ++ List.map ((++) (str ++ " ")) oneToNine


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
