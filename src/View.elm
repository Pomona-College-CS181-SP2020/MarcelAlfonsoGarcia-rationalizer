module View exposing (..)

import Css exposing (..)
import Form exposing (FieldState, Form)
import Form.Error exposing (Error, ErrorValue)
import Form.Input as Input
import Form.Validate as Validate exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Lists exposing (measurements)
import Model exposing (..)
import Update exposing (parseAmntToFloat)


view : ( Model, Cmd Msg ) -> Html Msg
view ( { form, inRecipeMaybe, outRecipeMaybe }, _ ) =
    div
        [ class "page" ]
        [ Html.map FormMsg (formView form inRecipeMaybe)
        , case outRecipeMaybe of
            Just recipe ->
                div
                    [ class "submit-success" ]
                    [ h1
                        [ class "result-title" ]
                        [ text "This is my result!" ]
                    , div [ class "submitted-items" ] <|
                        List.map
                            recipeView
                            recipe.items
                    ]

            Nothing ->
                text ""
        ]


recipeView : Item -> Html Msg
recipeView item =
    div
        [ class "submitted-item" ]
        [ text (itemString item)
        ]


formView : Form CustomError Recipe -> Maybe Recipe -> Html Form.Msg
formView form inRecipeMaybe =
    let
        scale =
            Form.getFieldAsString "scale" form
    in
    div
        [ class "ingredient-list" ]
        [ h1
            [ class "scale-title" ]
            [ text "Let's set the scales" ]
        , scaleInput scale
        , div [ class "reset-button" ]
            [ button
                [ class "reset"
                , onClick (Form.Reset [])
                ]
                [ text "Reset" ]
            ]
        , div
            [ class "items"
            , style "clear" "both"
            ]
          <|
            List.map
                (itemView form)
                (Form.getListIndexes "items" form)
        ]


itemView : Form CustomError Recipe -> Int -> Html Form.Msg
itemView form i =
    let
        ingredient =
            Form.getFieldAsString ("items." ++ String.fromInt i ++ ".ingredient") form

        amount =
            Form.getFieldAsString ("items." ++ String.fromInt i ++ ".amount") form

        currMeasurement =
            Form.getFieldAsString ("items." ++ String.fromInt i ++ ".currMeasurement") form

        newMeasurement =
            Form.getFieldAsString ("items." ++ String.fromInt i ++ ".newMeasurement") form

        deleteStyle =
            [ class "button"
            , style "background" "red"
            , onClick (Form.RemoveItem "items" i)
            ]

        addStyle =
            [ class "button"
            , style "background" "blue"
            , onClick (Form.Append "items")
            ]

        measurementOptions =
            ( "", "Measurements" ) :: List.map (\s -> ( s, String.toUpper s )) measurements

        -- newMeasurementOptions =
        --     ( "", "Measurements" ) :: List.map (\s -> ( s, String.toUpper s )) (remove currMeasurement measurements)
    in
    div
        [ class "item" ]
        [ ingredientInput ingredient
        , amountInput amount
        , selectInput currMeasurement measurementOptions
        , selectInput newMeasurement measurementOptions
        , button
            addStyle
            [ text "+" ]
        , button
            deleteStyle
            [ text "-" ]
        ]


errorMessage : FieldState CustomError String -> Html Form.Msg
errorMessage state =
    case state.liveError of
        Just error ->
            div [ class "error-message" ]
                [ text (errorString error) ]

        Nothing ->
            span
                [ class "help-block" ]
                [ text "" ]


scaleInput : FieldState CustomError String -> Html Form.Msg
scaleInput state =
    case state.liveError of
        Just error ->
            div [ style "float" "left" ]
                [ div [ style "display" "inline-block" ]
                    [ Input.textInput
                        state
                        [ class "scale-input"
                        , placeholder "Scale"
                        , onClick (Form.Append "items")
                        , style "box-shadow" "0px 0px 10px red"
                        , style "border-color" "red"
                        , style "border-radius" "0.5px"
                        ]
                    ]
                , div [ style "display" "inline-block" ]
                    [ errorMessage state ]
                ]

        Nothing ->
            div [ style "float" "left" ]
                [ div []
                    [ Input.textInput
                        state
                        [ class "scale-input"
                        , placeholder "Scale"
                        , onClick (Form.Append "items")
                        , style "border" "none"
                        ]
                    ]
                ]


ingredientInput : FieldState CustomError String -> Html Form.Msg
ingredientInput state =
    case state.liveError of
        Just error ->
            div
                [ style "display" "inline-block"
                , style "margin-left" "15px"
                ]
                [ errorMessage state
                , Input.textInput
                    state
                    [ class "input"
                    , style "border-color" "red"
                    , style "border-radius" "0.5px"
                    , style "box-shadow" "0px 0px 5px red"
                    , placeholder "Ingredient"
                    ]
                ]

        Nothing ->
            div
                [ style "display" "inline-block"
                , style "margin-left" "15px"
                ]
                [ errorMessage state
                , Input.textInput
                    state
                    [ class "input"
                    , style "border" "none"
                    , style "border-radius" "4px"
                    , placeholder "Ingredient"
                    ]
                ]


amountInput : FieldState CustomError String -> Html Form.Msg
amountInput state =
    case state.liveError of
        Just error ->
            div [ style "display" "inline-block" ]
                [ errorMessage state
                , Input.textInput
                    state
                    [ class "input"
                    , style "box-shadow" "0px 0px 5px red"
                    , style "border-color" "red"
                    , style "border-radius" "0.5px"
                    , placeholder "Amount"
                    ]
                ]

        Nothing ->
            div [ style "display" "inline-block" ]
                [ errorMessage state
                , Input.textInput
                    state
                    [ class "input"
                    , placeholder "Amount"
                    , style "border" "none"
                    ]
                ]


selectInput : FieldState CustomError String -> List ( String, String ) -> Html Form.Msg
selectInput state options =
    case state.liveError of
        Just error ->
            div [ style "display" "inline-block" ]
                [ errorMessage state
                , Input.selectInput
                    options
                    state
                    [ class "input"
                    , style "box-shadow" "0px 0px 5px red"
                    , style "border-color" "red"
                    , style "border-radius" "0.5px"
                    ]
                ]

        Nothing ->
            div [ style "display" "inline-block" ]
                [ errorMessage state
                , Input.selectInput
                    options
                    state
                    [ class "input"
                    , style "border" "none"
                    ]
                ]


itemString : Item -> String
itemString item =
    if parseAmntToFloat item.amount == 1.0 then
        item.amount ++ " " ++ item.currMeasurement ++ " of " ++ item.ingredient ++ "\u{000D}\n"

    else
        item.amount ++ " " ++ item.currMeasurement ++ "s of " ++ item.ingredient ++ "\u{000D}\n"
