module Model exposing (..)

import Form exposing (Form)
import Form.Field as Field exposing (Field)
import Form.Validate as Validate exposing (..)
import Form.Error as Error exposing (Error, ErrorValue)

-- MODEL

type Msg
    = NoOp
    | FormMsg Form.Msg

type alias Model =
  { form : Form CustomError Recipe
  , recipeMaybe : Maybe Recipe
  }

type CustomError
    = Ooops
    | Nope
    | InvalidMeasurement
    | InvalidAmount

type alias Recipe =
  { items : List Item
  , scale : Float
  }

type alias Item =
  { ingredient : String
  , amount : String
  , measurement : String
  }

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

itemString : Item -> String
itemString item =
  item.amount ++ " " ++ item.measurement ++ " of " ++ item.ingredient ++ "\r\n"

recipeString : Recipe -> String
recipeString recipe =
  "scale: " ++ (List.foldl (\x acc -> (itemString x) ++ acc ) "" recipe.items)
  ++ " by: " ++ (String.fromFloat recipe.scale) ++ " times the amount"

errorString : ErrorValue CustomError -> String
errorString error =
  case error of
    Error.CustomError er -> case er of
            Ooops -> "Oops"
            Nope -> "Nope"
            InvalidMeasurement -> "Please select a valid measurement"
            InvalidAmount -> "This is not a correct amount"

    _ -> "Bruh what did you even do"

-- VALIDATION

validate : Validation CustomError Recipe
validate =
    map2 Recipe
        (field "items" (list validateItem))
        (field "scale" float)

validateItem : Validation CustomError Item
validateItem =
    map3 Item
         (field "ingredient" string)
         (field "amount" validateAmount)
         (field "measurement" validateMeasurement)

validateAmount : Validation CustomError String
validateAmount =
  customValidation
          string
          (\s ->
          case s of
            "one" -> Ok s
            _ -> Err (customError InvalidAmount)
          )

validateMeasurement : Validation CustomError String
validateMeasurement =
  customValidation
          string
          (\s ->
            case List.member s measurements of
              True -> Ok s
              _ ->  Err (customError InvalidMeasurement)
          )
