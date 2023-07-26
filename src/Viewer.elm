module Viewer exposing (..)

import Browser
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attribute
import Html.Styled.Events as Event
import Measure.Depth exposing (meter)
import Measure.Pressure exposing (bar)
import Measure.Volume exposing (liter)
import Plan exposing (Plan, plan)


main =
    let
        model =
            { mdd = "8", tank = "12", start = "195" }
    in
    Browser.sandbox
        { init = model
        , view = view >> Html.toUnstyled
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
    let
        tankOption volume =
            Html.option [ Attribute.value volume, Attribute.selected <| model.tank == volume ] [ Html.text <| volume ++ "l" ]
    in
    Html.header []
        [ Html.label [] [ Html.text "MDD" ]
        , Html.input [ Attribute.type_ "text", Attribute.size 6, Attribute.value model.mdd, Event.onInput UpdateMDD ] []
        , Html.label [] [ Html.text "Tank" ]
        , Html.select [ Event.onInput UpdateTank ] <| List.map (String.fromInt >> tankOption) [ 5, 8, 10, 12, 15 ]
        , Html.label [] [ Html.text "Start" ]
        , Html.input [ Attribute.type_ "text", Attribute.size 6, Attribute.value model.start, Event.onInput UpdateStart ] []
        ]


viewPlan : Maybe Plan -> Html msg
viewPlan pln =
    case pln of
        Just p ->
            Plan.view p

        Nothing ->
            Html.main_ []
                [ Html.p [] [ Html.text "Waiting for correct input" ] ]
