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
import Utils exposing (..)


view : Model -> Html Msg
view model =
    div [ ]
        [ nav
        , newPlayerPage model.temporaryPlayer model
        ]

newPlayerPage : Player -> Model -> Html Msg
newPlayerPage temporaryPlayer model =
   i [ A.class "center" ]
     [  bootstrap
        ,form [ onSubmit Msgs.AddNewPlayer ] 
        [ input
            [ A.type_ "text"
            , A.placeholder "Player Name"
            , onInput Msgs.AddNewPlayerName
            , A.value temporaryPlayer.name
            ]
            []
        , input
            [ A.type_ "text"
            , A.placeholder "Player ID"
            , onInput Msgs.AddNewPlayerId
            , A.value temporaryPlayer.id
            ]
            []
        , input
            [ A.type_ "text"
            , A.placeholder "Player level"
            , onInput stringToInt 
            , A.value <| if (temporaryPlayer.level == 0) then
                "" else toString temporaryPlayer.level 
            ]
            []
        , input
            [ A.type_ "submit"
            , A.value "Add player"
            , A.class "btn btn-success"]
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

