module Update exposing (..)

import Commands exposing (savePlayerCmd, saveNewPlayerCmd, deletePlayerCmd)
import Models exposing (..)
import Msgs exposing (Msg)
import Routing exposing (parseLocation)
import RemoteData
import List exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnFetchPlayers response ->
            ( { model | players = response }, Cmd.none )

        Msgs.OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        Msgs.ChangeLevel player howMuch ->
            let 
                updatedPlayer =
                    { player | level = player.level + howMuch }
            in
                ( model, savePlayerCmd updatedPlayer )

        Msgs.OnPlayerSave (Ok player) ->
            ( updatePlayer model player, Cmd.none )

        Msgs.OnPlayerSave (Err error) ->
            ( model, Cmd.none )

        Msgs.OnNewPlayerSave (Ok temporaryplayer) ->
            ( updateNewPlayer temporaryplayer model , Cmd.none )

        Msgs.OnNewPlayerSave (Err error) ->
            ( { model | showDialog = True }, Cmd.none )

        Msgs.DeletePlayer idToDelete ->
           deletePlayer model idToDelete

        Msgs.AddNewPlayer ->  
             ( clearForm model, saveNewPlayerCmd model.temporaryPlayer )

        Msgs.AddNewPlayerName newPlayerName -> 
            ( updateTemporaryPlayerName model newPlayerName, Cmd.none )

        Msgs.AddNewPlayerId newPlayerId -> 
            ( updateTemporaryPlayerId model newPlayerId, Cmd.none )

        Msgs.AddNewPlayerLevel newPlayerLevel -> 
            ( updateTemporaryPlayerLevel model newPlayerLevel, Cmd.none )

        Msgs.NoOp ->
            ( model, Cmd.none )

        Msgs.AcknowledgeDialog ->
            ( { model | showDialog = False }
            , Cmd.none
            )

updatePlayer : Model -> Player -> Model
updatePlayer model updatedPlayer =
    let
        pick currentPlayer =
            if updatedPlayer.id == currentPlayer.id then
                updatedPlayer
            else
                currentPlayer

        updatePlayerList players =
            List.map pick players

        updatedPlayers =
            RemoteData.map updatePlayerList model.players
    in
        { model | players = updatedPlayers }

deletePlayer : Model -> PlayerId -> ( Model, Cmd Msg )
deletePlayer model idToDelete =
    case model.players of
        RemoteData.Success players ->
            let
                newmodel = { model |
                    players = RemoteData.Success <|
                        List.filter (\p -> p.id /= idToDelete) players
                }
            in
                ( newmodel, deletePlayerCmd idToDelete ) 

        _ ->
            ( model, Cmd.none )

updateTemporaryPlayerId : Model -> PlayerId -> Model
updateTemporaryPlayerId model newPlayerId =
    let
        oldTempPlayer = model.temporaryPlayer
        newTempPlayer = { oldTempPlayer | id = newPlayerId }
    in
        updateTempPlayer newTempPlayer model

updateTemporaryPlayerName : Model -> PlayerName -> Model
updateTemporaryPlayerName model newPlayerName =
    let
        oldTempPlayer = model.temporaryPlayer
        newTempPlayer = { oldTempPlayer | name = newPlayerName }
    in
        updateTempPlayer newTempPlayer model

updateTemporaryPlayerLevel : Model -> PlayerLevel -> Model
updateTemporaryPlayerLevel model newPlayerLevel =
    let
        oldTempPlayer = model.temporaryPlayer
        newTempPlayer = { oldTempPlayer | level = newPlayerLevel }
    in
    
        updateTempPlayer newTempPlayer model

updateTempPlayer : Player -> Model -> Model
updateTempPlayer newTempPlayer model =
    { model | temporaryPlayer = newTempPlayer }

updateNewPlayer : Player -> Model -> Model
updateNewPlayer temporaryPlayer model =
    case model.players of
        RemoteData.Success players ->
            let
                newmodel = { model |
                    players = RemoteData.Success <|
                       append players [temporaryPlayer]
                }
            in
                newmodel
        _->
            model
            

clearForm : Model -> Model
clearForm model =
    let emptyPlayer =
        Player "" "" 0
    in
     { model | temporaryPlayer = emptyPlayer }
        


