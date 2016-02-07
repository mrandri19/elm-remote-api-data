module Main (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StartApp exposing (..)
import Task exposing (..)
import Effects exposing (..)
import Http exposing (getString)
import Debug exposing (..)


app =
    StartApp.start { init = init, view = view, update = update, inputs = inputs }


main =
    app.html


port tasks : Signal (Task.Task Effects.Never ())
port tasks =
    app.tasks


init : ( Model, Effects Action )
init =
    ( { data = "" }, Effects.none )


type alias Model =
    { data : String
    }


type Action
    = NoOp
    | FetchData
    | DisplayNewData (Maybe String)


view : Signal.Address Action -> Model -> Html
view address model =
    div
        [ id "content", class "container z-depth-2" ]
        [ div
            [ class "row" ]
            [ div
                [ class "col s12" ]
                [ p
                    []
                    [ text "Press button to fetch data from the server" ]
                , button [ class "waves-effect waves-light btn", onClick address FetchData ] [ text "fetch data" ]
                , p [] [ text ("The data is: " ++ model.data) ]
                ]
            ]
        ]


update : Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        NoOp ->
            ( model, Effects.none )

        FetchData ->
            ( model, fetchData )

        DisplayNewData maybeData ->
            ( { model | data = (Maybe.withDefault "NO DATA" (Debug.log "maybeData: " maybeData)) }, Effects.none )


fetchData : Effects Action
fetchData =
    Http.getString "http://localhost:8001/data.txt"
        |> Task.toMaybe
        |> Task.map DisplayNewData
        |> Effects.task


inputs : List (Signal Action)
inputs =
    []
