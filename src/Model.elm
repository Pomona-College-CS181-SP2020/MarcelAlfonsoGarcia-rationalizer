module Model exposing (..)

import Form exposing (Form)
import Form.Error as Error exposing (Error, ErrorValue)
import Form.Field as Field exposing (Field)
import Form.Validate as Validate exposing (..)
import Lists exposing (measurements, validAmounts)



-- MODEL


type Msg
    = NoOp
    | FormMsg Form.Msg


type alias Model =
    { form : Form CustomError Recipe
    , inRecipeMaybe : Maybe Recipe
    , outRecipeMaybe : Maybe Recipe
    }


type CustomError
    = BadIngredient
    | NoIngredient
    | InvalidMeasurement
    | InvalidAmount


type alias Recipe =
    { items : List Item
    , scale : Float
    }


type alias Item =
    { ingredient : String
    , amount : String
    , currMeasurement : String
    , newMeasurement : String
    }


errorString : ErrorValue CustomError -> String
errorString error =
    case error of
        Error.CustomError er ->
            case er of
                BadIngredient ->
                    "Ingredients don't have these characters!"

                NoIngredient ->
                    "Please put in your ingredient"

                InvalidMeasurement ->
                    "Please select a valid measurement"

                InvalidAmount ->
                    "I can't understand this value!"

        Error.InvalidFloat ->
            "Scale can only be a number!"

        Error.Empty ->
            "Please select a measurement"

        Error.InvalidString ->
            "Please input ingredient"

        _ ->
            "Error in input"



-- VALIDATION


validate : Validation CustomError Recipe
validate =
    map2 Recipe
        (field "items" (list validateItem))
        (field "scale" float)


validateItem : Validation CustomError Item
validateItem =
    map4 Item
        (field "ingredient" validateIngredient)
        (field "amount" validateAmount)
        (field "currMeasurement" validateMeasurement)
        (field "newMeasurement" validateMeasurement)


validateIngredient : Validation CustomError String
validateIngredient =
    customValidation
        string
        (\s ->
            case String.isEmpty s of
                True ->
                    Err (customError NoIngredient)

                False ->
                    case isAlpha s of
                        True ->
                            Ok s

                        False ->
                            Err (customError BadIngredient)
        )


validateAmount : Validation CustomError String
validateAmount =
    customValidation
        string
        (\s ->
            case List.member (String.toLower (String.trim s)) validAmounts of
                True ->
                    Ok s

                _ ->
                    case String.toFloat s of
                        Just x ->
                            Ok s

                        _ ->
                            case isValidFraction (String.trim s) of
                                True ->
                                    Ok s

                                False ->
                                    Err (customError InvalidAmount)
        )


isValidFraction : String -> Bool
isValidFraction str =
    case String.contains "/" str of
        True ->
            checkFraction (String.split "/" str)

        False ->
            False


checkFraction : List String -> Bool
checkFraction l =
    case List.head l of
        Just x ->
            case last l of
                Just y ->
                    True && (List.length l == 2) && checkFloats x y

                Nothing ->
                    False

        Nothing ->
            False


checkFloats : String -> String -> Bool
checkFloats x y =
    case String.toInt x of
        Just i ->
            case String.toInt y of
                Just 0 ->
                    False

                Nothing ->
                    False

                Just j ->
                    True

        Nothing ->
            False


last : List a -> Maybe a
last l =
    List.head (List.reverse l)


validateMeasurement : Validation CustomError String
validateMeasurement =
    customValidation
        string
        (\s ->
            case List.member s measurements of
                True ->
                    Ok s

                _ ->
                    Err (customError InvalidMeasurement)
        )


isAlpha : String -> Bool
isAlpha s =
    List.foldr (\x b -> Char.isAlpha x && b) True (String.toList s)
