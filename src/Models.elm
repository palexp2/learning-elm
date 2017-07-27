module Models exposing (..)

import RemoteData exposing (WebData)


type alias Model =
    { players : WebData (List Player)
    , route : Route
    , temporaryPlayer : Player
    }

initialModel : Route -> Model
initialModel route =
    { players = RemoteData.Loading
    , route = route
    , temporaryPlayer = Player "" "" 0
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

type Route
    = PlayersRoute
    | PlayerRoute PlayerId
    | NewPlayerRoute
    | NotFoundRoute

