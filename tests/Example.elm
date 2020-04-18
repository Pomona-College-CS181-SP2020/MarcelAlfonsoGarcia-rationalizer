module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import IngredientParser exposing (..)
import Parser exposing (..)

emptyRecipe : Test
emptyRecipe =
    test "empty recipe" <| \_ ->
            let
                input = ""
                output = { items = [], scale = 0.0 }
            in
                Expect.equal (parse input) output
