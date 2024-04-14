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
        , tankVolume : Volume
        }


details : Input -> Plan
details input =
    let
        mdd =
            input
                |> Input.mddOf

        tankVolume =
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
        , tankVolume = tankVolume
        }


type Entry
    = Single String Volume
    | Compound String (List ( String, Volume ))


entries : Labels -> Plan -> List Entry
entries labels (Plan { reserve, rise, minimum, halve, stop, total }) =
    [ Compound labels.minimum [ ( labels.reserve, reserve ), ( labels.rise, rise ), ( labels.stop, stop ) ]
    , Single labels.return halve
    , Single labels.total total
    ]


volumeOf : Entry -> Volume
volumeOf entry =
    case entry of
        Single _ v ->
            v

        Compound _ components ->
            components
                |> List.map Tuple.second
                |> List.foldl Volume.add Volume.zeroLiter


view : Labels -> Plan -> Html msg
view labels ((Plan { tankVolume }) as aPlan) =
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
                , Html.td [ Attribute.css headerTdStyle ] [ Html.text labels.subCategory ]
                , Html.td [ Attribute.css headerTdStyle ] [ Html.text labels.volume ]
                , Html.td [ Attribute.css headerTdStyle ] [ Html.text labels.pressure ]
                ]
            ]
        , Html.tbody [] (List.concatMap (viewRow tankVolume) rows)
        ]


viewRow : Volume -> Entry -> List (Html msg)
viewRow tankVolume entry =
    case entry of
        Single label value ->
            viewSingleEntry tankVolume label value

        Compound label components ->
            viewCompoundEntry tankVolume label components


viewSingleEntry : Volume -> String -> Volume -> List (Html msg)
viewSingleEntry tankVolume label volume =
    Html.tr []
        [ Html.td [] [ Html.text label ]
        , Html.td [] []
        , Html.td [] [ Html.text <| Volume.toString volume ]
        , Html.td [] [ Html.text <| Pressure.toString <| Pressure.scale (Volume.factor volume tankVolume) Pressure.oneBar ]
        ]
        |> List.singleton


viewCompoundEntry : Volume -> String -> List ( String, Volume ) -> List (Html msg)
viewCompoundEntry tankVolume label components =
    let
        total =
            components
                |> List.map Tuple.second
                |> List.foldl Volume.add Volume.zeroLiter

        viewSubEntry : ( String, Volume ) -> Html msg
        viewSubEntry ( subLabel, subVolume ) =
            Html.tr []
                [ Html.td [] []
                , Html.td [] [ Html.text subLabel ]
                , Html.td [] [ Html.text <| Volume.toString subVolume ]
                , Html.td [] [ Html.text <| Pressure.toString <| Pressure.scale (Volume.factor subVolume tankVolume) Pressure.oneBar ]
                ]
    in
    Html.tr []
        [ Html.td [] [ Html.text label ]
        , Html.td [] []
        , Html.td [] [ Html.text <| Volume.toString <| total ]
        , Html.td [] [ Html.text <| Pressure.toString <| Pressure.scale (Volume.factor total tankVolume) Pressure.oneBar ]
        ]
        :: List.map viewSubEntry components
