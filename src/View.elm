module View exposing (..)

import Css exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Form exposing (Form, FieldState)
import Form.Input as Input
import Form.Error exposing (Error, ErrorValue)
import Form.Validate as Validate exposing (..)
import Model exposing (..)

view : (Model, Cmd Msg) -> Html Msg
view ({ form, inRecipeMaybe, outRecipeMaybe }, _) =
        div
        []
        [ Html.map FormMsg (formView form)
        , case inRecipeMaybe of
            Just recipe ->
                p [ class "submit-success" ] [ text (recipeString recipe) ]

            Nothing ->
                text ""
        , case outRecipeMaybe of
            Just recipe ->
                p [ class "submit-success" ] [ text (recipeString recipe) ]

            Nothing ->
                text ""
        ]

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
          [ h1 [style "color" "blue"] [text "Let's set the scales"]
          , Input.textInput
                    (scale)
                    [placeholder "Scale"
                    , onClick (Form.Append "items")]
          , errorMessage scale
          ,   div []
                    [ input
                      [ type_ "range"
                      , Html.Attributes.min "0"
                      , Html.Attributes.max "10"
                      , value (whatever scale.value)
                      ] []
                    , text (whatever scale.value)
                    ]
          , div [ class "items" ] <|
               (List.map
                  (itemView form)
                  (Form.getListIndexes "items" form))
          , div [class "buttons"]
                  [ button
                      [ class "Reset"
                      , onClick (Form.Reset [])
                      ]
                      [ text "Reset" ]
                  ]
          ]

whatever : Maybe String -> String
whatever s =
  case s of
    Just x -> x
    Nothing -> "0"

itemView : Form CustomError Recipe -> Int -> Html Form.Msg
itemView form i =
    let
        ingredient =
           Form.getFieldAsString ("items." ++ (String.fromInt i) ++ ".ingredient") form

        amount =
           Form.getFieldAsString ("items." ++ (String.fromInt i) ++ ".amount") form

        measurement =
           Form.getFieldAsString  ("items." ++ (String.fromInt i) ++ ".measurement") form

        selectStyle = [ style "color" "blue"
                                ]
        deleteStyle = [ class "remove"
                              , onClick (Form.RemoveItem "items" i)
                              , style "background" "red"
                              , style "color" "white"
                              ]
        addStyle =  [ class "add"
                            , onClick (Form.Append "items")
                            , style "background" "blue"
                            , style "color" "white"
                            ]
        measurementOptions =
                ( "", "Measurements" ) :: (List.map (\s -> ( s, String.toUpper s )) measurements)
    in
        div
            [ class "item" ]
            [ Input.textInput
                ingredient
                [placeholder "Ingredient"]
            , errorMessage ingredient
            , Input.textInput
                amount
                [placeholder "Amount"]
            , errorMessage amount
            , Input.selectInput
                measurementOptions
                measurement
                selectStyle
            , errorMessage measurement
            , button
                addStyle
                [text "+"]
            , button
                deleteStyle
                [ text "-" ]
            ]

errorMessage : FieldState CustomError String -> Html Form.Msg
errorMessage state =
    case state.liveError of
        Just error ->
            text (errorString error)
        Nothing ->
            span
                [ class "help-block" ]
                [ text "" ]
