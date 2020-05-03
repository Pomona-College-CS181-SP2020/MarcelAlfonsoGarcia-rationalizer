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


view : ( Model, Cmd Msg ) -> Html Msg
view ( { form, inRecipeMaybe, outRecipeMaybe }, _ ) =
    div
        [  style "background-color" "#1abc9c"
        -- style "background-image" "url(https://images-na.ssl-images-amazon.com/images/I/712FtCEg5BL._AC_SL1000_.jpg)"
        -- , style "background-repeat" "no-repeat"
        , style "background-size" "cover"
        , style "width" "100vw"
        , style "height" "100vh"
        ]
        [ Html.map FormMsg (formView form inRecipeMaybe)
        , case inRecipeMaybe of
            Just recipe ->
                div
                    [ class "submit-success"
                    , style "margin" "10px"
                    , style "width" "700px"
                    , style "height" "190px"
                    , style "border-radius" "5px"
                  --  , style "background-color" "#1abc9c"
                    , style "float" "right"
                    ]
                    [ h1
                        [ style "color" "white"
                        , style "padding" "5px 5px"
                        , style "margin" "5px 0px"
                        , style "fontFamily" "sans-serif"
                        , style "text-align" "center"
                        , style "font-size" "45px"
                        ]
                        [ text "Is this your recipe?" ]
                    , div [ class "submitted-items" ] <|
                        List.map
                            recipeView
                            recipe.items
                    ]

            Nothing ->
                text ""
        , case outRecipeMaybe of
            Just recipe ->
                div
                    [ class "submit-success"
                    , style "margin" "10px auto"
                    , style "width" "580px"
                    , style "border-radius" "5px"
                  --  , style "background-color" "#1abc9c"
                    , style "clear" "both"
                    ]
                    [ h1
                        [ style "color" "white"
                        , style "padding" "5px 5px"
                        , style "margin" "5px 0px"
                        , style "text-align" "center"
                        , style "fontFamily" "sans-serif"
                        , style "font-size" "45px"
                        ]
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
        [ class "submitted-item"
        , style "padding" "5px 5px"
        , style "margin" "2px auto"
        , style "fontFamily" "sans-serif"
        , style "fontSize" "32px"
        , style "text-align" "center"
        ]
        [ text (itemString item)
        ]


outputRecipeView : Item -> Html Msg
outputRecipeView item =
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
        [ class "ingredient-list"
        , style "margin" "10px"
        , style "width" "700px"
        , style "border-radius" "5px"
      --  , style "background-color" "#1abc9c"
        , style "float" "left"
        ]
        [ h1
            [ style "color" "white"
            , style "padding" "5px 5px"
            , style "margin" "5px 0px"
            , style "fontFamily" "sans-serif"
            , style "text-align" "center"
            , style "font-size" "45px"
            ]
            [ text "Let's set the scales" ]
        , scaleInput scale
        , div [ class "buttons" ]
            [ button
                [ class "Reset"
                , onClick (Form.Reset [])
                , style "width" "60px"
                , style "background-color" "#ff6200"
                , style "color" "white"
                , style "padding" "14px 10px"
                , style "margin-top" "5px"
                , style "margin-bottom" "10px"
                , style "margin-right" "20px"
                , style "border" "none"
                , style "border-radius" "4px"
                , style "font-size" "16px"
                , style "float" "right"
                ]
                [ text "Reset" ]
            ]
        , div [ class "items"
                , style "clear" "both"
                ] <|
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
            [ class "remove"
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

        addStyle =
            [ class "add"
            , onClick (Form.Append "items")
            , style "background" "blue"
            , style "color" "white"
            , style "width" "4.75 px"
            , style "height" "4.75 px"
            , style "padding" "5px 10px"
            , style "margin-top" "2px"
            , style "margin-bottom" "2px"
            , style "margin-left" "5px"
            , style "border" "none"
            , style "border-radius" "4px"
            , style "font-size" "16px"
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

scaleInput : FieldState CustomError String -> Html Form.Msg
scaleInput state =
  let
          errorStyle =
              [ placeholder "Scale"
              , onClick (Form.Append "items")
              , style "display" "block"
              , style "width" "50px"
              , style "padding" "14px 10px"
              , style "margin-top" "10px"
              , style "margin-bottom" "10px"
              , style "margin-left" "20px"
              , style "box-shadow" "0px 0px 10px red"
              , style "border-color" "red"
              , style "border-radius" "0.5px"
              , style "float" "left"
              ]

          normalStyle =
                [ placeholder "Scale"
                , onClick (Form.Append "items")
                , style "display" "block"
                , style "width" "50px"
                , style "padding" "14px 10px"
                , style "margin-top" "10px"
                , style "margin-bottom" "10px"
                , style "margin-left" "20px"
                , style "border" "none"
                , style "border-radius" "4px"
                , style "float" "left"
                ]
  in
      case state.liveError of
          Just error ->
              Input.textInput
                  state
                  (errorStyle)

          Nothing ->
              Input.textInput
                  state
                  (normalStyle)

ingredientInput : FieldState CustomError String -> Html Form.Msg
ingredientInput state =
  let
          errorStyle =
              [ style "width" "150px"
              , style "padding" "5px 5px"
              , style "margin-top" "2px"
              , style "margin-bottom" "2px"
              , style "margin-left" "20px"
              , style "border-color" "red"
              , style "border-color" "red"
              , style "border-radius" "0.5px"
              , style "box-shadow" "0px 0px 5px red"
              , placeholder "Ingredient"
              ]

          normalStyle =
                [ style "width" "150px"
                , style "padding" "5px 5px"
                , style "margin-top" "2px"
                , style "margin-bottom" "2px"
                , style "margin-left" "20px"
                , style "border" "none"
                , style "border-radius" "4px"
                , placeholder "Ingredient"
                ]
  in
      case state.liveError of
          Just error ->
              Input.textInput
                  state
                  (errorStyle)

          Nothing ->
              Input.textInput
                  state
                  (normalStyle)

amountInput : FieldState CustomError String -> Html Form.Msg
amountInput state =
  let
          errorStyle =
              [ style "width" "150px"
              , style "padding" "5px 5px"
              , style "margin-top" "2px"
              , style "margin-bottom" "2px"
              , style "margin-left" "5px"
              , style "box-shadow" "0px 0px 5px red"
              , style "border-color" "red"
              , style "border-radius" "0.5px"
              , placeholder "Amount"
              ]

          normalStyle =
                [ style "width" "150px"
                , style "padding" "5px 5px"
                , style "margin-top" "2px"
                , style "margin-bottom" "2px"
                , style "margin-left" "5px"
                , style "border" "none"
                , style "border-radius" "4px"
                , placeholder "Amount"
                ]
  in
      case state.liveError of
          Just error ->
              Input.textInput
                  state
                  (errorStyle)

          Nothing ->
              Input.textInput
                  state
                  (normalStyle)

selectInput : FieldState CustomError String -> List (String, String) -> Html Form.Msg
selectInput state options=
  let
          errorStyle =
              [ style "width" "130px"
              , style "padding" "5px 5px"
              , style "margin-top" "2px"
              , style "margin-bottom" "2px"
              , style "margin-left" "5px"
              , style "box-shadow" "0px 0px 5px red"
              , style "border-color" "red"
              , style "border-radius" "0.5px"
              ]

          normalStyle =
                [ style "width" "130px"
                , style "padding" "5px 5px"
                , style "margin-top" "2px"
                , style "margin-bottom" "2px"
                , style "margin-left" "5px"
                , style "border" "none"
                , style "border-radius" "4px"
                ]
  in
      case state.liveError of
          Just error ->
              Input.selectInput
                  options
                  state
                  errorStyle

          Nothing ->
              Input.selectInput
                  options
                  state
                  normalStyle


remove : a -> List a -> List a
remove x l =
  List.foldr (\s acc -> if x == s then acc else acc ++ [x]) [] l
