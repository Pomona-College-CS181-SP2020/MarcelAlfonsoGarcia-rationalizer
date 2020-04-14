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
view ({ form, recipeMaybe }, _) =
        div
        []
        [ Html.map FormMsg (formView form)
        , case recipeMaybe of
            Just recipe ->
                p [ class "alert alert-success" ] [ text (recipeString recipe) ]

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
          [ div [ class "items" ] <|
              List.map
                  (itemView form)
                  (Form.getListIndexes "items" form)
          , textGroup
              ("Scale")
              (scale)
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

        selectStyle = [ style "color" "blue"
                                ]
        deleteStyle = [ class "remove"
                              , onClick (Form.RemoveItem "items" i)
                              , style "background" "red"
                              ]
        measurementOptions =
                ( "", "Measurements" ) :: (List.map (\s -> ( s, String.toUpper s )) measurements)
    in
        div
            [ class "item" ]
            [ Input.textInput
                ingredient
                [placeholder "Ingredient"]
            , Input.textInput
                amount
                [placeholder "Amount"]
            , Input.selectInput
                measurementOptions
                measurement
                selectStyle
            , button
                deleteStyle
                [ text "Remove" ]
            ]

textGroup :  String -> FieldState CustomError String -> Html Form.Msg
textGroup str state =
    formGroup state.liveError
        [ Input.textInput state
            [ class "form-control"
            , value (Maybe.withDefault "" state.value)
            , placeholder str
            ]
        ]

selectGroup : List (String, String) ->  FieldState CustomError String -> Html Form.Msg
selectGroup options state =
        formGroup state.liveError
        [ Input.selectInput options state [ class "form-control" ] ]

formGroup : Maybe (ErrorValue CustomError) -> List (Html Form.Msg) -> Html Form.Msg
formGroup maybeError inputs =
    div
        [ class ("row form-group " ++ (errorClass maybeError)) ]
        [ colN 5
            inputs
        , colN 4
            [ errorMessage maybeError ]
        ]

colN : Int -> List (Html Form.Msg) -> Html Form.Msg
colN i content =
    div [ class ("col-xs-" ++ String.fromInt i) ] content

errorClass : Maybe error -> String
errorClass maybeError =
    Maybe.map (\_ -> "has-error") maybeError |> Maybe.withDefault ""

errorMessage : Maybe (ErrorValue CustomError) -> Html Form.Msg
errorMessage maybeError =
    case maybeError of
        Just error ->
            p
                [ class "help-block" ]
                [ text (errorString error)]

        Nothing ->
            span
                [ class "help-block" ]
                [ text "" ]
