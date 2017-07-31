module View exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Html.Attributes as A
import RemoteData
import Dialog

import Models exposing (Model, PlayerId, Player)
import Routing exposing (playersPath)
import Models exposing (Model)
import Msgs exposing (Msg)
import Players.Edit
import Players.List
import Players.Add
import Utils exposing (..)


view : Model -> Html Msg
view model =
    div [ A.style [ ( "margin", "45px" ) ]] 
        [ bootstrap
        , Dialog.view
            (if model.showDialog then
                Just (dialogConfig model)
             else
                Nothing
            )
        , page model
        ]


page : Model -> Html Msg
page model =
    case model.route of
        Models.PlayersRoute ->
            Players.List.view model.players

        Models.PlayerRoute id ->
            playerEditPage model id

        Models.NewPlayerRoute ->
            Players.Add.view model

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
    form [ onSubmit Msgs.AddNewPlayer ] 
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

dialogConfig : Model -> Dialog.Config Msg
dialogConfig model =
    { closeMessage = Nothing
    , containerClass = Nothing
    , header = Just (h3 [] [ text "Error" ])
    , body = Just (text ("This ID is already taken, please choose another one"))
    , footer =
        Just
            (a 
                [ A.class "fa fa-check"
                , onClick Msgs.AcknowledgeDialog
                ]
                [text "ok"
                ]
            )
    }

