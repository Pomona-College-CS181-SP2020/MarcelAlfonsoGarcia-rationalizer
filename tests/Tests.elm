module Tests exposing (..)

import Expect exposing (Expectation)
import Model exposing (checkFloats, checkFraction, isValidFraction, last)
import Test exposing (..)
import Update exposing (..)
import View exposing (..)



-- VALIDATION TESTING


testIsValidFraction : Test
testIsValidFraction =
    test "is valid fraction" <|
        \_ ->
            let
                input =
                    [ "3/2", "1", "1/0", "a", "1/a", "1+1/2", "1 1/2", "1.0/2.0", "" ]

                output =
                    [ True, False, False, False, False, False, False, False, False ]
            in
            Expect.equal output (List.map isValidFraction input)


testCheckFraction : Test
testCheckFraction =
    test "check fraction" <|
        \_ ->
            let
                input =
                    [ [ "3", "2" ], [ "1", "0" ], [ "1 1", "2" ], [ "1+1", "2" ], [ "1" ], [ "a" ], [ "1", "a" ], [ "", "" ] ]

                output =
                    [ True, False, False, False, False, False, False, False ]
            in
            Expect.equal output (List.map checkFraction input)



-- testCheckFloats : Test
-- testCheckFloats =
--     test "check floats" <| \_ ->
--             let
--                 str1 = [ "1", "1.0", "a", "1.0", "a", "", "1.0", "", "a", "0", "1" ]
--                 str2 = [ "2", "1.2", "1.0", "a", "a", "1.0", "", "a", "", "1", "0" ]
--                 output = [ True, True, False, False, False, False, False, False, False, True, False ]
--             in
--                 Expect.equal (checkFloats input) output
-- RATIONALIZER TESTING


testRationalizeNoScale : Test
testRationalizeNoScale =
    test "rationalize with a scale of 1" <|
        \_ ->
            let
                item =
                    { ingredient = "a", amount = "1", currMeasurement = "cup", newMeasurement = "pound" }

                input =
                    { items = [ item ], scale = 1 }

                output =
                    { items = [ item ], scale = 1 }
            in
            Expect.equal (Just output) (rationalize input)


testRationalizeTripleScale : Test
testRationalizeTripleScale =
    test "rationalize with a scale of 3" <|
        \_ ->
            let
                item =
                    { ingredient = "a", amount = "1", currMeasurement = "cup", newMeasurement = "pound" }

                input =
                    { items = [ item ], scale = 3 }

                output =
                    { items = [ { item | amount = "3" } ], scale = 3 }
            in
            Expect.equal (Just output) (rationalize input)


testRationalizeChangeMeasurement : Test
testRationalizeChangeMeasurement =
    test "rationalize with a change of measurement" <|
        \_ ->
            let
                item =
                    { ingredient = "a", amount = "1", currMeasurement = "CUP", newMeasurement = "OUNCE" }

                input =
                    { items = [ item ], scale = 3 }

                output =
                    { items = [ { item | amount = "24", currMeasurement = "ounce" } ], scale = 3 }
            in
            Expect.equal (Just output) (rationalize input)


testFindDirectConversion : Test
testFindDirectConversion =
    test "find direct conversion" <|
        \_ ->
            let
                input =
                    [ ( "tablespoon", "teaspoon" ), ( "teaspoon", "tablespoon" ), ( "a", "teaspoon" ), ( "teaspoon", "a" ), ( "", "" ), ( "teaspoon", "" ), ( "", "teaspoon" ) ]

                output =
                    [ Just 3.0, Just (1 / 3), Nothing, Nothing, Nothing, Nothing, Nothing ]
            in
            Expect.equal output (List.map (\( x, y ) -> findDirectConversion x y) input)


testRoundToEighth : Test
testRoundToEighth =
    test "round to eighth value" <|
        \_ ->
            let
                input =
                    [ 1.0, 0.5, 0.2 ]

                output =
                    [ 1.0, 0.5, 0.125 ]
            in
            Expect.equal output (List.map (roundToEighth input))


testParseAmntToFloat : Test
testParseAmntToFloat =
    test "parse the list of amounts to floats" <|
        \_ ->
            let
                input =
                    [ "half", "ten", "twenty one", "thirty seven and one eighth", "nineteen and a half", "nineteen and half", "1/2", "1/0", "", "a", "0" ]

                output =
                    [ 0.5, 10, 21, 37.125, 19.5, 0.5, 0.0, 0.0, 0.0, 0.0 ]
            in
            Expect.equal output (List.map parseAmntToFloat input)


testFindIndex : Test
testFindIndex =
    test "find indices" <|
        \_ ->
            let
                input =
                    [ "half", "ten", "twenty one", "thirty seven and one eighth", "nineteen and a half", "nineteen and half", "", "a", "0" ]

                output =
                    [ Just 0.5, Just 10, Just 21, Just 37.125, Just 19.5, Nothing, Nothing, Nothing, Nothing ]
            in
            Expect.equal output (List.map findIndex input)


testFindFractionValue : Test
testFindFractionValue =
    test "find the value of a fraction" <|
        \_ ->
            let
                input =
                    [ "2", "1/2", "1/0", "a", "", "1/a", "a/1", "0" ]

                output =
                    [ 0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]
            in
            Expect.equal output (List.map findFractionValue input)


testDivide : Test
testDivide =
    test "divide strings" <|
        \_ ->
            let
                input =
                    [ ( "1", "2" ), ( "0", "1" ), ( "1", "0" ), ( "a", "1" ), ( "1", "a" ) ]

                output =
                    [ 0.5, 0, 0, 0, 0 ]
            in
            Expect.equal output (List.map (\( x, y ) -> divide x y) input)
