module Update exposing (..)

import Form exposing (Form)
import Model exposing (..)
import Lists exposing (validAmounts)

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
                    Just { recipe | items = newItems }

scaleItem : Float -> Item ->Item
scaleItem scale item =
                let
                  newAmt = case String.toFloat (item.amount) of
                                            Just i -> String.fromFloat (roundToEighth (i*scale))
                                            Nothing -> String.fromFloat (roundToEighth ((parseAmntToFloat item.amount)*scale))
                in
                  { item | amount = newAmt }
                  -- case item.isScalable of
                  --   True ->
                  --         { item | amount = newAmt }
                  --   False ->
                  --         { item | amount = item.amount }

roundToEighth : Float -> Float
roundToEighth x =
    Basics.toFloat (Basics.floor (x * 8)) / 8

parseAmntToFloat : String -> Float
parseAmntToFloat amount =
          case String.toFloat amount of
                  Just i -> i
                  Nothing -> case findIndex amount of
                                      Just l -> l
                                      Nothing -> 0


findIndex : String-> Maybe Float
findIndex str =
    findIndexHelp 0 ((==) str) validAmounts

findIndexHelp : Float -> (String -> Bool) -> List String -> Maybe Float
findIndexHelp index predicate list =
    case list of
        [] ->
            Nothing

        x :: xs ->
            if predicate x then
                Just (approximateValue index)
            else
                findIndexHelp (index + 1) predicate xs

approximateValue : Float -> Float
approximateValue x =
      Basics.toFloat (Basics.round ((x/9) * 8)) / 8
