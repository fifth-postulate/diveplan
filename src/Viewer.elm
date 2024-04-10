module Viewer exposing (..)

import Browser
import Css exposing (..)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attribute
import Html.Styled.Events as Event
import I8n exposing (Labels)
import Measure.Depth exposing (meter)
import Measure.Pressure exposing (bar)
import Measure.Sac exposing (litersPerMinute)
import Measure.Volume exposing (liter)
import Plan exposing (Plan)
import Plan.Input as Input
import Plan.Tank as Tank


main =
    let
        model =
            { mdd = "8", volume = "12", pressure = "195", sac = "20" }
    in
    Browser.sandbox
        { init = model
        , view = view I8n.en >> Html.toUnstyled
        , update = update
        }


type alias Model =
    { mdd : String
    , volume : String
    , pressure : String
    , sac : String
    }


type Msg
    = UpdateMDD String
    | UpdateVolume String
    | UpdatePressure String
    | UpdateSac String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateMDD mdd ->
            { model | mdd = mdd }

        UpdateVolume tank ->
            { model | volume = tank }

        UpdatePressure start ->
            { model | pressure = start }

        UpdateSac sac ->
            { model | sac = sac }


view : Labels -> Model -> Html Msg
view labels model =
    let
        depth =
            model.mdd
                |> String.toInt
                |> Maybe.andThen meter

        volume =
            model.volume
                |> String.toInt
                |> Maybe.map toFloat
                |> Maybe.andThen liter

        pressure =
            model.pressure
                |> String.toInt
                |> Maybe.map toFloat
                |> Maybe.andThen bar

        rate =
            model.sac
                |> String.toInt
                |> Maybe.map toFloat
                |> Maybe.andThen litersPerMinute

        tank =
            Tank.tryFrom volume pressure

        plan =
            { depth = depth, tank = tank, rate = rate }
                |> Input.tryFrom
                |> Maybe.map Plan.from
    in
    Html.div []
        [ header labels model
        , viewPlan labels plan
        ]


header : Labels -> Model -> Html Msg
header labels model =
    let
        labelStyle : List Style
        labelStyle =
            [ after [ property "content" "':'" ] ]

        inputStyle : List Style
        inputStyle =
            [ marginLeft <| px 3, marginRight <| px 5 ]

        tankOption volume =
            Html.option [ Attribute.value volume, Attribute.selected <| model.volume == volume ] [ Html.text <| volume ++ "l" ]
    in
    Html.header []
        [ Html.label [ Attribute.css labelStyle ] [ Html.text labels.mdd ]
        , Html.input [ Attribute.css inputStyle, Attribute.type_ "text", Attribute.size 6, Attribute.value model.mdd, Event.onInput UpdateMDD ] []
        , Html.label [ Attribute.css labelStyle ] [ Html.text labels.volume ]
        , Html.select [ Attribute.css inputStyle, Event.onInput UpdateVolume ] <| List.map (String.fromInt >> tankOption) [ 5, 8, 10, 12, 15 ]
        , Html.label [ Attribute.css labelStyle ] [ Html.text labels.pressure ]
        , Html.input [ Attribute.css inputStyle, Attribute.type_ "text", Attribute.size 6, Attribute.value model.pressure, Event.onInput UpdatePressure ] []
        , Html.label [ Attribute.css labelStyle ] [ Html.text labels.sac ]
        , Html.input [ Attribute.css inputStyle, Attribute.type_ "text", Attribute.size 6, Attribute.value model.sac, Event.onInput UpdateSac ] []
        ]


viewPlan : Labels -> Maybe Plan -> Html msg
viewPlan labels pln =
    case pln of
        Just p ->
            Plan.view labels p

        Nothing ->
            Html.main_ []
                [ Html.p [] [ Html.text labels.waiting ] ]
