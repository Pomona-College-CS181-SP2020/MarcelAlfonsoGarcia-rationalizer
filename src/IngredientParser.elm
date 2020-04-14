module IngredientParser exposing (..)

import View exposing (view)
import Update exposing (init, update)
import Model exposing (..)
import Parser exposing (..)

parse : String -> Recipe
parse recipe =
  case (run recipeParser recipe) of
    Ok x -> x
    Err _ -> { items = [], scale = 0.0 }

-- RECIPE

recipeParser : Parser Recipe
recipeParser =
  succeed Recipe
      |. spaces
      |= itemsParser
      |= float

-- ITEM

itemsParser : Parser (List Item)
itemsParser =
  loop [] loopHelper

loopHelper : List Item -> Parser (Step (List Item) (List Item))
loopHelper revItems =
  oneOf
  [ succeed (\item -> Loop ( item :: revItems ))
        |. spaces
        |= itemParser
  , succeed () |> map (\_ -> Done (List.reverse revItems))
  ]

itemParser : Parser Item
itemParser =
  succeed Item
      |. spaces
      |= ingredientParser
      |= quantityParser
      |= measurementParser

-- INGREDIENT

ingredientParser : Parser String
ingredientParser =
   getChompedString <| chompWhile (\b -> Char.isAlpha b)

-- AMOUNT

quantityParser : Parser String
quantityParser =
    getChompedString <| chompWhile (\b -> Char.isAlpha b)

-- MEASUREMENTS

measurementParser : Parser String
measurementParser =
  getChompedString <| chompWhile (\b -> Char.isAlpha b)
