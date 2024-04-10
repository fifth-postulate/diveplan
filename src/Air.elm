module Air exposing (Plan, plan)

import Css exposing (..)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attribute
import I8n exposing (Labels)
import Measure.Depth as Depth exposing (fiveMeters)
import Measure.Pressure as Pressure
import Measure.Sac as Sac
import Measure.Time exposing (threeMinutes)
import Measure.Volume as Volume exposing (Volume, oneLiter)
import Plan.DiveTime as DiveTime
import Plan.Input as Input exposing (Input)
import Plan.Tank as Tank


plan : Labels -> Input -> Html msg
plan labels input =
    view labels <| details input


type Plan
    = Plan
        { halve : Volume
        , minimum : Volume
        , reserve : Volume
        , rise : Volume
        , stop : Volume
        , total : Volume
        , volume : Volume
        }


details : Input -> Plan
details input =
    let
        mdd =
            input
                |> Input.mddOf

        volume =
            input
                |> Input.tankOf
                |> Tank.volume

        isDeepDive =
            mdd
                |> Depth.inMeters
                |> (<) 20

        reserve =
            if isDeepDive then
                Volume.scale 900 oneLiter

            else
                Volume.scale 600 oneLiter

        stop =
            input
                |> Input.sacOf
                |> Sac.atDepth fiveMeters
                |> Sac.times threeMinutes

        rise =
            input
                |> Input.sacOf
                |> Sac.averageDuringRiseFrom mdd
                |> Sac.times (DiveTime.riseFrom mdd)

        minimum =
            reserve
                |> Volume.add rise
                |> Volume.add stop

        total =
            input
                |> Input.tankOf
                |> Tank.airVolume

        halve =
            Volume.add minimum total
                |> Volume.scale 0.5
    in
    Plan
        { halve = halve
        , minimum = minimum
        , reserve = reserve
        , rise = rise
        , stop = stop
        , total = total
        , volume = volume
        }


entries : Labels -> Plan -> List ( String, Volume )
entries labels (Plan { reserve, rise, minimum, halve, volume, stop, total }) =
    [ ( labels.reserve, reserve )
    , ( labels.rise, rise )
    , ( labels.stop, stop )
    , ( labels.minimum, minimum )
    , ( labels.return, halve )
    , ( labels.total, total )
    ]


view : Labels -> Plan -> Html msg
view labels ((Plan { volume }) as aPlan) =
    let
        headerTdStyle : List Style
        headerTdStyle =
            [ borderBottomStyle solid
            , borderBottomColor <| rgb 0 0 0
            , borderBottomWidth <| px 1
            ]

        rows =
            entries labels aPlan
    in
    Html.table [ Attribute.css [ borderCollapse collapse ] ]
        [ Html.thead [ Attribute.css [ fontWeight bold ] ]
            [ Html.tr []
                [ Html.td [ Attribute.css headerTdStyle ] [ Html.text labels.category ]
                , Html.td [ Attribute.css headerTdStyle ] [ Html.text labels.volume ]
                , Html.td [ Attribute.css headerTdStyle ] [ Html.text labels.pressure ]
                ]
            ]
        , Html.tbody [] (List.map (viewRow volume) rows)
        ]


viewRow : Volume -> ( String, Volume ) -> Html msg
viewRow volume ( label, value ) =
    Html.tr []
        [ Html.td [] [ Html.text label ]
        , Html.td [] [ Html.text <| Volume.toString value ]
        , Html.td [] [ Html.text <| Pressure.toString <| Pressure.scale (Volume.factor value volume) Pressure.oneBar ]
        ]
