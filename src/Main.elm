module Main exposing (..)

import Browser
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)

-- MAIN

main = Browser.sandbox
        { init = init
        , view = \model -> toUnstyled (view model)
        , subscriptions = subscriptions
        , update = update
        }
-- MODEL

type alias Ingredient =
  { ingredient : String
  , amount : String
  , measurement : String
  }

init : (Ingredient, Cmd Actions)
init =
  ({ ingredient = ""
  , amount = ""
  , measurement = ""
  }, Cmd.none)

-- UPDATE

type Actions
   = SetIngredient String
   | SetAmount String
   | SetMeasurement String
   | AddIngredient
   | RemoveIngredient
   | InsertIngredient
   | EditIngredient
   | SubmitRecipe

update : Actions -> Ingredient -> (Ingredient, Cmd Actions)
update msg ingredient =
  case msg of
    SetIngredient newMsg ->
      (  { ingredient | ingredient = newMsg }, Cmd.none )
    SetAmount newAmnt ->
      (  { ingredient | amount = newAmnt }, Cmd.none )
    SetMeasurement newMeasure ->
      (  { ingredient | measurement = newMeasure }, Cmd.none )
    AddIngredient ->
      (  { ingredient | ingredient = "add" }, Cmd.none )
    RemoveIngredient ->
      (  { ingredient | amount = "remove" }, Cmd.none )
    InsertIngredient ->
      (  { ingredient | measurement = "insert" }, Cmd.none )
    EditIngredient ->
      (  { ingredient | measurement = "edit" }, Cmd.none )
    SubmitRecipe ->
      (  { ingredient | measurement = "submit" }, Cmd.none )

-- SUBSCRIPTIONS

subscriptions : Ingredient -> Sub Actions
subscriptions model =
  Sub.none

-- VIEW

view : Ingredient -> Html Actions
view model =
   div []
    [ h1 [ css [ paddingLeft (cm 3) ] ][ text "Recipe" ],
     styledForm []
          [ div []
               [ styledInput [ placeholder "Insert ingredient", value model.ingredient, onInput SetIngredient ] []
               , styledInput [ placeholder "Insert amount", value model.amount, onInput SetAmount ] []
               , measurementSelect model
               , styledButton [ onClick RemoveIngredient ] [ text "Remove" ]
               , styledButton [ onClick EditIngredient ] [ text "Edit" ] ]
           , div []
               [ styledButton [ onClick AddIngredient ] [ text "Add" ] ]
           , div []
               [ styledButton [ onClick SubmitRecipe ] [ text "Submit" ] ]
          ]
    ]

measurementSelect : Ingredient -> Html Actions
measurementSelect model =
  styledSelect [ placeholder "Insert measurement", value model.measurement, onInput SetMeasurement ]
  (List.map simpleOption measurements)

simpleOption : String -> Html Actions
simpleOption val =
  option [ value val ] [ text val ]

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
  ]
-- STYLE

styledForm : List (Attribute msg) -> List (Html msg) -> Html msg
styledForm =
    styled Html.Styled.form
        [ borderRadius (px 5)
        , backgroundColor (hex "#f2f2f2")
        , padding (px 20)
        , Css.width (px 300)
        ]


styledInput : List (Attribute msg) -> List (Html msg) -> Html msg
styledInput =
    styled Html.Styled.input
        [ display block
        , Css.width (px 260)
        , padding2 (px 12) (px 20)
        , margin2 (px 8) (px 0)
        , border (px 0)
        , borderRadius (px 4)
        ]

styledSelect : List (Attribute msg) -> List (Html msg) -> Html msg
styledSelect =
    styled Html.Styled.select
        [ display block
        , Css.width (px 100)
        , padding2 (px 10) (px 10)
        , margin2 (px 3) (px 0)
        , border (px 0)
        , borderRadius (px 4)
        ]

styledButton : List (Attribute msg) -> List (Html msg) -> Html msg
styledButton =
    styled Html.Styled.button
        [ Css.width (px 300)
        , backgroundColor (hex "#397cd5")
        , color (hex "#fff")
        , padding2 (px 14) (px 20)
        , marginTop (px 10)
        , border (px 0)
        , borderRadius (px 4)
        , fontSize (px 16)
        ]
