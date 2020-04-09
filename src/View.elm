module View exposing (..)

import Css exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Form exposing (Form, FieldState)
import Form.Input as Input
import Form.Validate as Validate exposing (..)
import Model exposing (..)

view : (Model, Cmd Msg) -> Html Msg
view ({ form }, _) =
    Html.map FormMsg (formView form)


formView : Form CustomError Recipe -> Html Form.Msg
formView form =
  let
       scale =
         Form.getFieldAsString "scale" form
  in
       div
          [ class "ingredient-list"
           ,  style "color" "green"
           ]
          [ div [ class "items" ] <|
              List.map
                  (itemView form)
                  (Form.getListIndexes "items" form)
          , Input.textInput
              scale
              [ placeholder "Scale" ]
          , div [class "buttons"]
                  [ button
                      [ class "add"
                      , onClick (Form.Append "items")
                      ]
                      [ text "Add" ]
                  ]
          , div [class "buttons"]
                  [ button
                      [ class "submit"
                      , onClick (Form.Submit)
                      ]
                      [ text "Submit" ]
                  ]
          ]

itemView : Form CustomError Recipe -> Int -> Html Form.Msg
itemView form i =
    let
        ingredient =
           Form.getFieldAsString ("items." ++ (String.fromInt i) ++ ".ingredient") form

        amount =
           Form.getFieldAsString ("items." ++ (String.fromInt i) ++ ".amount") form

        measurement =
           Form.getFieldAsString  ("items." ++ (String.fromInt i) ++ ".measurement") form

        buttonStyle = [ style "color" "blue"
                                ]
        measurementOptions =
                ( "", "--" ) :: (List.map (\s -> ( s, String.toUpper s )) measurements)
    in
        div
            [ class "item" ]
            [ Input.textInput
                ingredient
                []
            , Input.textInput
                amount
                []
            , Input.selectInput
                measurementOptions
                measurement
                buttonStyle
            , button
                [ class "remove"
                , onClick (Form.RemoveItem "items" i)
                ]
                [ text "Remove" ]
            ]

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
