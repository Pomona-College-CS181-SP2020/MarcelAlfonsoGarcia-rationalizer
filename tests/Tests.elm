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


testRationalize : Test
testRationalize =
    test "rationalize" <|
        \_ ->
            let
                item =
                    { ingredient = "a", amount = "1", currMeasurement = "cup", newMeasurement = "pound", isScalable = True }

                input =
                    { items = [ item ], scale = 1 }

                output =
                    { items = [ item ], scale = 1 }
            in
            Expect.equal (Just output) (rationalize input)



-- testChangeMeasurement : Test
-- testChangeMeasurement =
--     test "change measurements" <| \_ ->
--             let
--                 str1 = [ "1", "1.0", "a", "1.0", "a", "", "1.0", "", "a", "0", "1" ]
--                 str2 = [ "2", "1.2", "1.0", "a", "a", "1.0", "", "a", "", "1", "0" ]
--                 output = [ True, True, False, False, False, False, False, False, False, True, False ]
--             in
--                 Expect.equal (checkFloats input) output
--
-- testFindDirectConversion : Test
-- testFindDirectConversion =
--     test "find direct conversion" <|
--         \_ ->
--             let
--                 str1 =
--                     [ "tablespoon", "teaspoon", "a", "teaspoon", "a", "", "teaspoon", "" ]
--
--                 str2 =
--                     [ "teaspoon", "tablespoon", "teaspoon", "a", "teaspoon", "", "" ]
--
--                 output =
--                     [ Just 3.0, Just (1/3), Nothing, Nothing, Nothing, Nothing ]
--             in
--             Expect.equal output (findDirectConversion input)
--
-- testScaleItem : Test
-- testScaleItem =
--     test "scale item" <| \_ ->
--             let
--                 str1 = [ "1", "1.0", "a", "1.0", "a", "", "1.0", "", "a", "0", "1" ]
--                 str2 = [ "2", "1.2", "1.0", "a", "a", "1.0", "", "a", "", "1", "0" ]
--                 output = [ True, True, False, False, False, False, False, False, False, True, False ]
--             in
--                 Expect.equal (checkFloats input) output
--


testRoundToEighth : Test
testRoundToEighth =
    test "round to eighth value" <|
        \_ ->
            let
                input =
                    [ "1.0", "0.5", "0.1" ]

                output =
                    [ "1.0", "0.5", "0.125" ]
            in
            Expect.equal (List.map roundToEighth input) output


testParseAmntToFloat : Test
testParseAmntToFloat =
    test "find indices" <|
        \_ ->
            let
                input =
                    [ "one half", "half ", "ten", "twenty one", "thirty seven and one eighth", "nineteen and a half", "nineteen and half", "1/2", "1/0", "", "a", "0" ]

                output =
                    [ 0.5, 0.5, 10, 21, 37.125, 19.2, 0.5, 0.0, 0.0, 0.0, 0.0 ]
            in
            Expect.equal output (List.map parseAmntToFloat input)


testFindIndex : Test
testFindIndex =
    test "find indices" <|
        \_ ->
            let
                input =
                    [ "one half", "half ", "ten", "twenty one", "thirty seven and one eighth", "nineteen and a half", "nineteen and half", "", "a", "0" ]

                output =
                    [ Just 0.5, Just 0.5, Just 10, Just 21, Just 37.125, Just 19.2, Nothing, Nothing, Nothing, Nothing ]
            in
            Expect.equal output (List.map findIndex input)


testFindFractionValue : Test
testFindFractionValue =
    test "find the value of a fraction" <|
        \_ ->
            let
                int =
                    [ "2", "1/2", "1/0", "a", "", "1/a", "a/1", "0" ]

                output =
                    [ 2, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]
            in
            Expect.equal output (List.map findFractionValue input)



--
-- testDivide : Test
-- testDivide =
--     test "check floats" <| \_ ->
--             let
--                 str1 = [ "1", "1.0", "a", "1.0", "a", "", "1.0", "", "a", "0", "1" ]
--                 str2 = [ "2", "1.2", "1.0", "a", "a", "1.0", "", "a", "", "1", "0" ]
--                 output = [ True, True, False, False, False, False, False, False, False, True, False ]
--             in
--                 Expect.equal (checkFloats input) output
