module Model exposing (..)

import Form exposing (Form)
import Form.Field as Field exposing (Field)
import Form.Validate as Validate exposing (..)
import Form.Error as Error exposing (Error, ErrorValue)
import Lists exposing (measurements, validAmounts)

-- MODEL

type Msg
    = NoOp
    | FormMsg Form.Msg

type alias Model =
  { form : Form CustomError Recipe
  , inRecipeMaybe : Maybe Recipe
  , outRecipeMaybe : Maybe Recipe
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
  , currMeasurement : String
  , newMeasurement : String
  , isScalable : Bool
  }

itemString : Item -> String
itemString item =
  item.amount ++ " " ++ item.currMeasurement ++ " of " ++ item.ingredient ++ "\r\n"

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

    Error.InvalidFloat -> "Scale is not a correct value"

    Error.Empty -> "Please select a valid measurement"

    Error.InvalidString -> "Please input ingredient"

    _ -> "Error in input"

-- VALIDATION

validate : Validation CustomError Recipe
validate =
    map2 Recipe
        (field "items" (list validateItem))
        (field "scale" float)

validateItem : Validation CustomError Item
validateItem =
    map5 Item
         (field "ingredient" string)
         (field "amount" validateAmount)
         (field "currMeasurement" validateMeasurement)
         (field "newMeasurement" validateMeasurement)
         (field "isScalable" bool)

validateAmount : Validation CustomError String
validateAmount =
  customValidation
          string
          (\s ->
          case List.member (String.toLower (String.trim s)) validAmounts of
            True -> Ok s
            _ -> case String.toFloat s of
                     Just x -> Ok s
                     _ -> case isValidFraction (String.trim s) of
                              True -> Ok s
                              False -> Err (customError InvalidAmount)
          )

isValidFraction : String -> Bool
isValidFraction str =
  case String.contains "/" str of
    True -> checkFraction (String.split "/" str)
    False -> False

checkFraction : List String -> Bool
checkFraction l =
    case List.head l of
      Just x -> case last l of
                            Just y -> True && (List.length l == 2) && checkFloats x y
                            Nothing -> False
      Nothing -> False

checkFloats : String -> String -> Bool
checkFloats x y =
    case String.toInt x of
      Just i -> case String.toInt y of
                      Just 0 -> False
                      Nothing -> False
                      Just j -> True
      Nothing -> False

last :  List a -> Maybe a
last l = List.head (List.reverse l)

validateMeasurement : Validation CustomError String
validateMeasurement =
  customValidation
          string
          (\s ->
            case List.member s measurements of
              True -> Ok s
              _ ->  Err (customError InvalidMeasurement)
          )
