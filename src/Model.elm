module Model exposing (..)

import Form exposing (Form)
import Form.Field as Field exposing (Field)
import Form.Validate as Validate exposing (..)

-- MODEL

type Msg
    = NoOp
    | FormMsg Form.Msg

type alias Model =
  { form : Form CustomError Recipe
  , recipe : Maybe Recipe
  }

type CustomError
    = Ooops
    | Nope
    | AlreadyInput
    | InvalidAmount

type alias Recipe =
  { items : List Item
  , scale : String
  }

type alias Item =
  { ingredient : String
  , amount : String
  , measurement : String
  }

-- VALIDATION

validate : Validation CustomError Recipe
validate =
    map2 Recipe
        (field "items" (list validateItem))
        (field "scale" string)

validateItem : Validation CustomError Item
validateItem =
    map3 Item
         (field "ingredient" string)
         (field "amount" string)
         (field "measurement" string)
