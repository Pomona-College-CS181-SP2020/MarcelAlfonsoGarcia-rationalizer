module Update exposing (..)

import Form exposing (Form)
import Model exposing (..)

-- INITIALIZER

init : (Model, Cmd Msg)
init =
  ({ form = Form.initial [] validate
  , recipe = Nothing
  }, Cmd.none)

-- UPDATE

update : Msg -> (Model, Cmd Msg) -> (Model, Cmd Msg)
update msg ({ form } as model, _) =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        FormMsg formMsg ->
                case (formMsg, Form.getOutput form) of
                        ( Form.Submit, Just recipe) ->
                              ( { model | recipe = Just recipe }, Cmd.none )
                        _ ->
                              ({ model | form = Form.update validate formMsg form }, Cmd.none )
