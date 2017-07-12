module Players.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Models exposing (Player)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Routing exposing (playerPath)
import Html.Events exposing (onClick)


view : WebData (List Player) -> Html Msg
view response =
    div []
        [ nav
        , maybeList response
        ]


nav : Html Msg
nav =
    div 
        [ class "clearfix mb2 white bg-black"
        ]
        [ div [class "left h2 bold"] [ text "Players" ]
        , a 
            [href "newplayer.elm" 
            ]
            [ i [ class "right p2 white fa fa-plus-circle" ] 
                [text "  Add a player"]
            ]
        ]

maybeList : WebData (List Player) -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success players ->
            list players

        RemoteData.Failure error ->
            text (toString error)


list : List Player -> Html Msg
list players =
    div []
        [ table []
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , th [] [ text "Name" ]
                    , th [] [ text "Level" ]
                    , th [] [ div [] [ text "Actions" ]]
                    ]
                ]
            , tbody [] (List.map playerRow players)
            ]
        ]


playerRow : Player -> Html Msg
playerRow player =
    tr []
        [ td [] [ text player.id ]
        , td [] [ text player.name ]
        , td [ class "center" ] [ text (toString player.level) ]
        , td [] [ editBtn player
        , deleteBtn player]
        ]


editBtn : Player -> Html.Html Msg
editBtn player =
    let
        path =
            playerPath player.id
    in
        a
            [ class "btn regular"
            , href path
            ]
            [ i [ class "fa fa-pencil mr1" ] [] ]


deleteBtn : Player -> Html Msg
deleteBtn player =
    let
        message =
            Msgs.DeletePlayer player.id
    in
        a
            [ class "btn regular"
            , onClick message
            ]
            [ i [ class "fa fa-trash-o fa-lg" ] [] ]
