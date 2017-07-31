module Commands exposing (..)

import Debug
import Http
import Json.Decode as Decode
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Json.Encode as Encode
import Msgs exposing (Msg)
import Models exposing (PlayerId, Player)
import RemoteData

fetchPlayers : Cmd Msg
fetchPlayers =
    Http.get fetchPlayersUrl playersDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchPlayers

fetchPlayersUrl : String
fetchPlayersUrl =
    "http://localhost:4000/players"

playerUrl : PlayerId -> String
playerUrl playerId =
    "http://localhost:4000/players/" ++ playerId


savePlayerRequest : Player -> Http.Request Player
savePlayerRequest player =
    Http.request
        { body = playerEncoder player |> Http.jsonBody
        , expect = Http.expectJson playerDecoder
        , headers = []
        , method = "PATCH"
        , timeout = Nothing
        , url = playerUrl player.id
        , withCredentials = False
        }

savePlayerCmd : Player -> Cmd Msg
savePlayerCmd player =
    savePlayerRequest player
        |> Http.send Msgs.OnPlayerSave


saveNewPlayerRequest : Player -> Http.Request Player
saveNewPlayerRequest player =
    Http.request
        { body = playerEncoder player |> Http.jsonBody
        , expect = Http.expectJson playerDecoder
        , headers = []
        , method = "POST"
        , timeout = Nothing
        , url = "http://localhost:4000/players"
        , withCredentials = False
        }

saveNewPlayerCmd : Player -> Cmd Msg
saveNewPlayerCmd player =
    saveNewPlayerRequest player
        |> Http.send Msgs.OnPlayerSave


deletePlayerRequest : PlayerId -> Http.Request PlayerId
deletePlayerRequest idToDelete = 
     Http.request
        { body = Encode.object [] |> Http.jsonBody
        , expect = Http.expectString 
        , headers = []
        , method = "DELETE"
        , timeout = Nothing
        , url = playerUrl idToDelete
        , withCredentials = False
        }

deletePlayerCmd : PlayerId -> Cmd Msg
deletePlayerCmd idToDelete =
    Debug.log "hdfgtyut"
    (deletePlayerRequest idToDelete
        |> Http.send (\_ -> Msgs.NoOp))

-- DECODERS

playersDecoder : Decode.Decoder (List Player)
playersDecoder =
    Decode.list playerDecoder

playerDecoder : Decode.Decoder Player
playerDecoder =
    decode Player
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "level" Decode.int

playerEncoder : Player -> Encode.Value
playerEncoder player =
    let
        attributes =
            [ ( "id", Encode.string player.id )
            , ( "name", Encode.string player.name )
            , ( "level", Encode.int player.level )
            ]
    in
        Encode.object attributes

