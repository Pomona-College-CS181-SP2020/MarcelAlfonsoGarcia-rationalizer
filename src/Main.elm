module Main exposing (..)

import Browser
import View exposing (view)
import Update exposing (init, update)

-- MAIN

main = Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
