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
        , update = update
        }
-- MODEL

type alias Ingredient =
  { ingredient : String
  , amount : String
  , measurement : String
  }

init : Ingredient
init =
  { ingredient = ""
  , amount = ""
  , measurement = ""
  }

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

update : Actions -> Ingredient -> Ingredient
update msg ingredient =
  case msg of
    SetIngredient newMsg ->
      { ingredient | ingredient = newMsg }
    SetAmount newAmnt ->
      { ingredient | amount = newAmnt }
    SetMeasurement newMeasure ->
      { ingredient | measurement = newMeasure }
    AddIngredient ->
      { ingredient | ingredient = "add" }
    RemoveIngredient ->
      { ingredient | amount = "remove" }
    InsertIngredient ->
      { ingredient | measurement = "insert" }
    EditIngredient ->
      { ingredient | measurement = "edit" }
    SubmitRecipe ->
      { ingredient | measurement = "submit" }

-- VIEW

view : Ingredient -> Html Actions
view model =
   div []
    [ h1 [ css [ paddingLeft (cm 3) ] ][ text "Recipe" ],
     styledForm []
          [ div []
               [ styledInput [ placeholder "Insert ingredient", value model.ingredient, onInput SetIngredient ] []
               , styledInput [ placeholder "Insert amount", value model.ingredient, onInput SetAmount ] []
               , styledSelect [ placeholder "Insert measurement", value model.ingredient, onInput SetMeasurement ]
                     [ option [ value "tbsp" ] [ text "tbsp" ]
                       , option [value "cup" ] [ text "cup" ]
                     ]
               , styledButton [ onClick RemoveIngredient ] [ text "Remove" ]
               , styledButton [ onClick EditIngredient ] [ text "Edit" ] ]
           , div []
               [ styledButton [ onClick AddIngredient ] [ text "Add" ] ]
           , div []
               [ styledButton [ onClick SubmitRecipe ] [ text "Submit" ] ]
          ]
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
        , Css.width (px 70)
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
