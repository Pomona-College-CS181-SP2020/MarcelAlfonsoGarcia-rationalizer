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
import Lists exposing (measurements)

view : (Model, Cmd Msg) -> Html Msg
view ({ form, inRecipeMaybe, outRecipeMaybe }, _) =
        div
        []
        [ Html.map FormMsg (formView form inRecipeMaybe)
        , case inRecipeMaybe of
            Just recipe ->
                    recipeView recipe

            Nothing ->
                text ""
        , case outRecipeMaybe of
            Just recipe ->
                    outputRecipeView recipe

            Nothing ->
                text ""
        ]

recipeView : Recipe -> Html Msg
recipeView recipe =
                  div
                    [ class "submit-success"
                     , style "margin" "10px"
                     , style "width" "580px"
                     , style "border-radius" "5px"
                     , style "background-color" "#f2f2f2"
                     , style "float" "right"
                    ]
                    [ text (recipeString recipe) ]

outputRecipeView : Recipe -> Html Msg
outputRecipeView recipe =
                  div
                    [ class "submit-success"
                     , style "margin" "10px auto"
                     , style "width" "580px"
                     , style "border-radius" "5px"
                     , style "background-color" "red"
                    ]
                    [ text (recipeString recipe) ]

formView : Form CustomError Recipe -> Maybe Recipe -> Html Form.Msg
formView form inRecipeMaybe =
  let
       scale =
         Form.getFieldAsString "scale" form
  in
       div
          [ class "ingredient-list"
           , style "margin" "10px"
           , style "width" "580px"
           , style "border-radius" "5px"
           , style "background-color" "#f2f2f2"
           , style "float" "left"
           ]
          [ h1
              [ style "color" "blue"
              , style "padding" "5px 5px"
              , style "margin" "5px 130px"
              , style "fontFamily" "sans-serif"
              ]
              [text "Let's set the scales"]
          , Input.textInput
                    (scale)
                    [placeholder "Scale"
                    , onClick (Form.Append "items")
                    , style "display" "block"
                    , style "width" "50px"
                    , style "padding" "5px 5px"
                    , style "margin" "4px 10px"
                    , style "border" "none"
                    , style "border-radius" "4px"
                    ]
          , errorMessage scale
          , div [ class "items" ] <|
               (List.map
                  (itemView form)
                  (Form.getListIndexes "items" form))
          , div [class "buttons"]
                  [ button
                      [ class "Reset"
                      , onClick (Form.Reset [])
                      , style "width" "560px"
                      , style "background-color" "green"
                      , style "color" "white"
                      , style "padding" "14px 20px"
                      , style "margin-top" "5px"
                      , style "margin-bottom" "10px"
                      , style "margin-left" "10px"
                      , style "border" "none"
                      , style "border-radius" "4px"
                      , style "font-size" "16px"
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

        inputStyle s = [ style "width" "150px"
                                , style "padding" "5px 5px"
                                , style "margin-top" "2px"
                                , style "margin-bottom" "2px"
                                , style "margin-left" "10px"
                                , style "border" "none"
                                , style "border-radius" "4px"
                                , placeholder s
                                ]
        selectStyle = [ style "width" "150px"
                              , style "padding" "5px 5px"
                              , style "margin-top" "2px"
                              , style "margin-bottom" "2px"
                              , style "margin-left" "10px"
                              , style "border" "none"
                              , style "border-radius" "4px"
                              ]
        deleteStyle = [ class "remove"
                              , onClick (Form.RemoveItem "items" i)
                              , style "background" "red"
                              , style "color" "white"
                              , style "width" "100 px"
                              , style "height" "100 px"
                              , style "padding" "5px 10px"
                              , style "margin-top" "2px"
                              , style "margin-bottom" "2px"
                              , style "margin-left" "5px"
                              , style "border" "none"
                              , style "border-radius" "4px"
                              , style "font-size" "16px"
                              ]
        addStyle =  [ class "add"
                            , onClick (Form.Append "items")
                            , style "background" "blue"
                            , style "color" "white"
                            , style "width" "4.75 px"
                            , style "height" "4.75 px"
                            , style "padding" "5px 10px"
                            , style "margin-top" "2px"
                            , style "margin-bottom" "2px"
                            , style "margin-left" "10px"
                            , style "border" "none"
                            , style "border-radius" "4px"
                            , style "font-size" "16px"
                            ]
        measurementOptions =
                ( "", "Measurements" ) :: (List.map (\s -> ( s, String.toUpper s )) measurements)
    in
        div
            [ class "item" ]
            [ Input.textInput
                ingredient
                (inputStyle "Ingredient")
            , errorMessage ingredient
            , Input.textInput
                amount
                (inputStyle "Amount")
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
