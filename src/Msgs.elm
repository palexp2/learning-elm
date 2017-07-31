module Msgs exposing (..)

import Http
import Models exposing (..)
import Navigation exposing (Location)
import RemoteData exposing (WebData)


type Msg
    = OnFetchPlayers (WebData (List Player))
    | OnLocationChange Location
    | ChangeLevel Player Int
    | OnPlayerSave (Result Http.Error Player)
    | DeletePlayer PlayerId
    | AddNewPlayer
    | AddNewPlayerName PlayerName
    | AddNewPlayerId PlayerId
    | AddNewPlayerLevel PlayerLevel
    | NoOp
    | AcknowledgeDialog
    
