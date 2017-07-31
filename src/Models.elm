module Models exposing (..)

import RemoteData exposing (WebData)
import Html exposing (..)

type alias Model =
    { players : WebData (List Player)
    , route : Route
    , temporaryPlayer : Player
    , showDialog : Bool
    }

initialModel : Route -> Model
initialModel route =
    { players = RemoteData.Loading
    , route = route
    , temporaryPlayer = Player "" "" 0
    , showDialog = False
    }

type alias PlayerId =
    String

type alias PlayerName =
    String

type alias PlayerLevel =
    Int

type alias Player =
    { id : PlayerId
    , name : PlayerName
    , level : PlayerLevel
    }
type alias Config msg = 
    { closeMessage : Maybe msg
    , containerClass : Maybe String
    , header : Maybe (Html msg)
    , body : Maybe (Html msg)
    , footer : Maybe (Html msg)
    }

type Route
    = PlayersRoute
    | PlayerRoute PlayerId
    | NewPlayerRoute
    | NotFoundRoute

