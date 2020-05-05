module Main exposing (..)

import Browser
import Update exposing (init, update)
import View exposing (view)



-- MAIN


main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
