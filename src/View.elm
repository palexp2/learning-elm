module View exposing (..)

import Html exposing (Html, div, text, form, input)
import Html.Events exposing (onClick, onInput, onSubmit)
import Html.Attributes as A
import RemoteData

import Models exposing (Model, PlayerId)
import Routing exposing (playersPath)
import Models exposing (Model)
import Msgs exposing (Msg)
import Players.Edit
import Players.List


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        Models.PlayersRoute ->
            Players.List.view model.players

        Models.PlayerRoute id ->
            playerEditPage model id

        Models.NewPlayerRoute ->
            newPlayerPage model

        Models.NotFoundRoute ->
            notFoundView


playerEditPage : Model -> PlayerId -> Html Msg
playerEditPage model playerId =
    case model.players of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading ..."

        RemoteData.Success players ->
            let
                maybePlayer =
                    players
                        |> List.filter (\player -> player.id == playerId)
                        |> List.head
            in
                case maybePlayer of
                    Just player ->
                        Players.Edit.view player

                    Nothing ->
                        notFoundView

        RemoteData.Failure err ->
            text (toString err)

newPlayerPage : Model -> Html Msg
newPlayerPage model =
    form [ onSubmit Msgs.AddNewPlayer]
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

stringToInt : String -> Msg 
stringToInt input =
    String.toInt input
        |> \result ->
            case result of
                Err msg -> Msgs.NoOp

                Ok level -> Msgs.AddNewPlayerLevel level

notFoundView : Html Msg
notFoundView =
    div []
        [ text "Not found"
        ]
