module Update exposing (..)

import Form exposing (Form)
import Model exposing (..)

-- INITIALIZER

init : (Model, Cmd Msg)
init =
  ({ form = Form.initial [] validate
  , inRecipeMaybe = Nothing
  , outRecipeMaybe = Nothing
  }, Cmd.none)

-- UPDATE

update : Msg -> (Model, Cmd Msg) -> (Model, Cmd Msg)
update msg ({ form } as model, _) =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        FormMsg formMsg ->
                case (formMsg, Form.getOutput form) of
                        ( _, Just recipe) ->
                              ( { model | form = Form.update validate formMsg form, inRecipeMaybe = Just recipe, outRecipeMaybe = (rationalize recipe) }, Cmd.none )
                        _ ->
                              ({ model | form = Form.update validate formMsg form }, Cmd.none )

-- RATIONALIZER

rationalize : Recipe -> Maybe Recipe
rationalize recipe =
                  let
                    newItems = List.map (scaleItem recipe.scale) recipe.items
                  in
                    Just { recipe | items = newItems, scale = 1 }

scaleItem : Float -> Item ->Item
scaleItem scale item =
                let
                  newAmt = case String.toFloat (item.amount) of
                                            Just i -> String.fromFloat (i*scale)
                                            Nothing -> "0"
                in
                  case item.isScalable of
                    True ->
                          { item | amount = newAmt }
                    False ->
                          { item | amount = item.amount }
