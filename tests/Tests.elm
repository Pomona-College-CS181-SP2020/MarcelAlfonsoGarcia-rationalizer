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
                    [ True, False, False, False, False, False, False, True, False ]
            in
            Expect.equal (List.map isValidFraction input) output


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
            Expect.equal (List.map checkFraction input) output



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
                    { ingredient = "a", amount = "one", currMeasurement = "cup", newMeasurement = "pound", isScalable = True }

                input =
                    { items = [ item ], scale = 1 }

                output =
                    { items = [ item ], scale = 1 }
            in
            Expect.equal (rationalize input) (Just output)



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
--     test "find direct conversion" <| \_ ->
--             let
--                 str1 = [ "1", "1.0", "a", "1.0", "a", "", "1.0", "", "a", "0", "1" ]
--                 str2 = [ "2", "1.2", "1.0", "a", "a", "1.0", "", "a", "", "1", "0" ]
--                 output = [ True, True, False, False, False, False, False, False, False, True, False ]
--             in
--                 Expect.equal (checkFloats input) output
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
-- testRoundToEighth : Test
-- testRoundToEighth =
--     test "round to eighth value" <| \_ ->
--             let
--                 input = [ "1.0", "0.5", "0.1" ]
--                 output = [ "1.0", "0.5", "0.125"]
--             in
--                 Expect.equal (List.map (roundToEighth) input) output
--
-- testParseAmntToFloat : Test
-- testParseAmntToFloat =
--     test "parse amount to floats" <| \_ ->
--             let
--                 input = [ "1", "1.0", "one", "one and a half", "1/2", "", "one and half", "a", "1/0"]
--                 output = [ True, True, False, False, False, False, False, False, False, True, False ]
--             in
--                 Expect.equal (List.map (parseAmntToFloat) input) output
--
-- testFindIndex : Test
-- testFindIndex =
--     test "check floats" <| \_ ->
--             let
--                 str1 = [ "1", "1.0", "a", "1.0", "a", "", "1.0", "", "a", "0", "1" ]
--                 str2 = [ "2", "1.2", "1.0", "a", "a", "1.0", "", "a", "", "1", "0" ]
--                 output = [ True, True, False, False, False, False, False, False, False, True, False ]
--             in
--                 Expect.equal (checkFloats input) output
--
-- testFindIndexHelp : Test
-- testFindIndexHelp =
--     test "check floats" <| \_ ->
--             let
--                 str1 = [ "1", "1.0", "a", "1.0", "a", "", "1.0", "", "a", "0", "1" ]
--                 str2 = [ "2", "1.2", "1.0", "a", "a", "1.0", "", "a", "", "1", "0" ]
--                 output = [ True, True, False, False, False, False, False, False, False, True, False ]
--             in
--                 Expect.equal (checkFloats input) output
--
-- testFindFractionValue : Test
-- testFindFractionValue =
--     test "check floats" <| \_ ->
--             let
--                 str1 = [ "1", "1.0", "a", "1.0", "a", "", "1.0", "", "a", "0", "1" ]
--                 str2 = [ "2", "1.2", "1.0", "a", "a", "1.0", "", "a", "", "1", "0" ]
--                 output = [ True, True, False, False, False, False, False, False, False, True, False ]
--             in
--                 Expect.equal (checkFloats input) output
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
