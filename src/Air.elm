module Air exposing (Configuration, plan)

import Html exposing (Html)
import Measure.Pressure exposing (Pressure)
import Measure.Volume exposing (Volume, liter)


type alias Configuration =
    { tank : Volume
    , start : Pressure
    }


plan : Configuration -> Html msg
plan configuration =
    view <| details configuration


type alias Details =
    { reserve : Volume
    , rise : Volume
    , minimum : Volume
    , halve : Volume
    , tank : Volume
    }


details : Configuration -> Details
details { tank, start } =
    let
        reserve =
            liter 600 |> Maybe.withDefault Measure.Volume.oneLiter

        rise =
            liter 250 |> Maybe.withDefault Measure.Volume.oneLiter

        minimum =
            Measure.Volume.add reserve rise

        total =
            Measure.Pressure.volume tank start

        halve =
            Measure.Volume.add minimum total
                |> Measure.Volume.scale 0.5
    in
    { reserve = reserve
    , rise = rise
    , minimum = minimum
    , halve = halve
    , tank = tank
    }


view : Details -> Html msg
view { reserve, rise, minimum, halve, tank } =
    Html.table []
        [ Html.thead []
            [ Html.tr []
                [ Html.td [] [ Html.text "Categorie" ]
                , Html.td [] [ Html.text "Volume" ]
                , Html.td [] [ Html.text "Druk" ]
                ]
            ]
        , Html.tbody []
            [ Html.tr []
                [ Html.td [] [ Html.text "Reserve" ]
                , Html.td [] [ Html.text <| Measure.Volume.toString reserve ]
                , Html.td [] [ Html.text <| Measure.Pressure.toString <| Measure.Pressure.scale (Measure.Volume.factor reserve tank) Measure.Pressure.oneBar ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text "Opstijging" ]
                , Html.td [] [ Html.text <| Measure.Volume.toString rise ]
                , Html.td [] [ Html.text <| Measure.Pressure.toString <| Measure.Pressure.scale (Measure.Volume.factor rise tank) Measure.Pressure.oneBar ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text "Minimum" ]
                , Html.td [] [ Html.text <| Measure.Volume.toString minimum ]
                , Html.td [] [ Html.text <| Measure.Pressure.toString <| Measure.Pressure.scale (Measure.Volume.factor minimum tank) Measure.Pressure.oneBar ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text "Omkeerdruk" ]
                , Html.td [] [ Html.text <| Measure.Volume.toString halve ]
                , Html.td [] [ Html.text <| Measure.Pressure.toString <| Measure.Pressure.scale (Measure.Volume.factor halve tank) Measure.Pressure.oneBar ]
                ]
            ]
        ]
