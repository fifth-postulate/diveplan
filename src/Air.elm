module Air exposing (Plan, plan)

import Css exposing (..)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attribute
import I8n exposing (Labels)
import Measure.Depth as Depth
import Measure.Pressure as Pressure
import Measure.Volume as Volume exposing (Volume, oneLiter)
import Plan.Input as Input exposing (Input)
import Plan.Tank as Tank exposing (Tank)


plan : Labels -> Input -> Html msg
plan labels input =
    view labels <| details input


type Plan
    = Plan
        { reserve : Volume
        , rise : Volume
        , minimum : Volume
        , halve : Volume
        , tank : Volume
        }


details : Input -> Plan
details input =
    let
        volume =
            input
                |> Input.tankOf
                |> Tank.volume

        isDeepDive =
            input
                |> Input.mddOf
                |> Depth.inMeters
                |> (<) 20

        reserve =
            Volume.scale 600 oneLiter

        rise =
            Volume.scale 250 oneLiter

        minimum =
            Volume.add reserve rise

        total =
            input
                |> Input.tankOf
                |> Tank.airVolume

        halve =
            Volume.add minimum total
                |> Volume.scale 0.5
    in
    Plan
        { reserve = reserve
        , rise = rise
        , minimum = minimum
        , halve = halve
        , tank = volume
        }


view : Labels -> Plan -> Html msg
view labels (Plan { reserve, rise, minimum, halve, tank }) =
    let
        headerTdStyle : List Style
        headerTdStyle =
            [ borderBottomStyle solid
            , borderBottomColor <| rgb 0 0 0
            , borderBottomWidth <| px 1
            ]
    in
    Html.table [ Attribute.css [ borderCollapse collapse ] ]
        [ Html.thead [ Attribute.css [ fontWeight bold ] ]
            [ Html.tr []
                [ Html.td [ Attribute.css headerTdStyle ] [ Html.text labels.category ]
                , Html.td [ Attribute.css headerTdStyle ] [ Html.text labels.volume ]
                , Html.td [ Attribute.css headerTdStyle ] [ Html.text labels.pressure ]
                ]
            ]
        , Html.tbody []
            [ Html.tr []
                [ Html.td [] [ Html.text labels.reserve ]
                , Html.td [] [ Html.text <| Volume.toString reserve ]
                , Html.td [] [ Html.text <| Pressure.toString <| Pressure.scale (Volume.factor reserve tank) Pressure.oneBar ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text labels.rise ]
                , Html.td [] [ Html.text <| Volume.toString rise ]
                , Html.td [] [ Html.text <| Pressure.toString <| Pressure.scale (Volume.factor rise tank) Pressure.oneBar ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text labels.minimum ]
                , Html.td [] [ Html.text <| Volume.toString minimum ]
                , Html.td [] [ Html.text <| Pressure.toString <| Pressure.scale (Volume.factor minimum tank) Pressure.oneBar ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text labels.return ]
                , Html.td [] [ Html.text <| Volume.toString halve ]
                , Html.td [] [ Html.text <| Pressure.toString <| Pressure.scale (Volume.factor halve tank) Pressure.oneBar ]
                ]
            ]
        ]
