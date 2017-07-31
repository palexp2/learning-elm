module Players.Add exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Models exposing (Player,Model)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Routing exposing (playerPath, newPlayerPath)
import Html.Events exposing (onClick, onSubmit, onInput)
import Html.Attributes as A
import Routing exposing (playersPath)


view : Model -> Html Msg
view model =
    div [ ]
        [ nav
        , newPlayerPage model
        ]

newPlayerPage : Model -> Html Msg
newPlayerPage model =
   i [ A.class "center"]
     [ form [ onSubmit Msgs.AddNewPlayer ] 
        [ input
            [ A.type_ "text"
            , A.placeholder "Player Name"
            , onInput Msgs.AddNewPlayerName
            ]
            []
        , input
            [ A.type_ "text"
            , A.placeholder "Player ID"
            , onInput Msgs.AddNewPlayerId
            ]
            []
        , input
            [ A.type_ "text"
            , A.placeholder "Player level"
            , onInput stringToInt 
            ]
            []
        , input
            [ A.type_ "submit" ]
            []
        ]
        ]

stringToInt : String -> Msg 
stringToInt input =
    String.toInt input
        |> \result ->
            case result of
                Err msg -> Msgs.NoOp

                Ok level -> Msgs.AddNewPlayerLevel level

nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black p1" ]
        [ listBtn ]

listBtn : Html Msg
listBtn =
    a
        [ class "btn regular"
        , href playersPath
        ]
        [ i [ class "fa fa-chevron-left mr1" ] [], text "List" ]

