module Viewer exposing (..)

import Browser
import Depth exposing (meter)
import Html exposing (Html)
import Html.Attributes as Attribute
import Html.Events as Event
import Plan exposing (Plan, plan)
import Pressure exposing (bar)
import Time
import Volume exposing (liter)


main =
    let
        model =
            { mdd = "8", tank = "12", start = "195" }
    in
    Browser.sandbox
        { init = model
        , view = view
        , update = update
        }


type alias Model =
    { mdd : String
    , tank : String
    , start : String
    }


type Msg
    = UpdateMDD String
    | UpdateTank String
    | UpdateStart String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateMDD mdd ->
            { model | mdd = mdd }

        UpdateTank tank ->
            { model | tank = tank }

        UpdateStart start ->
            { model | start = start }


view : Model -> Html Msg
view model =
    let
        depth =
            model.mdd
                |> String.toInt
                |> Maybe.andThen meter

        volume =
            model.tank
                |> String.toInt
                |> Maybe.andThen liter

        pressure =
            model.start
                |> String.toInt
                |> Maybe.andThen bar

        plan =
            case ( depth, volume, pressure ) of
                ( Just mdd, Just tank, Just start ) ->
                    Just <| Plan.plan mdd tank start

                _ ->
                    Nothing
    in
    Html.div []
        [ header model
        , viewPlan plan
        ]


header : Model -> Html Msg
header model =
    Html.header []
        [ Html.label [] [ Html.text "MDD" ]
        , Html.input [ Attribute.type_ "text", Attribute.value model.mdd, Event.onInput UpdateMDD ] []
        , Html.label [] [ Html.text "Tank" ]
        , Html.select [ Event.onInput UpdateTank]
            [ Html.option [ Attribute.value "10", Attribute.selected <| model.tank == "10" ] [ Html.text "10l" ]
            , Html.option [ Attribute.value "12", Attribute.selected <| model.tank == "12" ] [ Html.text "12l" ]
            , Html.option [ Attribute.value "15", Attribute.selected <| model.tank == "15" ] [ Html.text "15l" ]
            ]
        , Html.label [] [ Html.text "Start" ]
        , Html.input [ Attribute.type_ "text", Attribute.value model.start, Event.onInput UpdateStart ] []
        ]


viewPlan : Maybe Plan -> Html msg
viewPlan pln =
    case pln of
        Just p ->
            Plan.view p

        Nothing ->
            Html.main_ []
                [ Html.p [] [ Html.text "Waiting for correct input" ] ]
