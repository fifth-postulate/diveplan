module Air exposing (Tank, plan)

import Html.Styled as Html exposing (Html)
import Measure.Pressure as Pressure exposing (Pressure)
import Measure.Volume as Volume exposing (Volume, oneLiter)


type alias Tank =
    { volume : Volume
    , start : Pressure
    }


plan : Tank -> Html msg
plan configuration =
    view <| details configuration


type Plan
    = Plan
        { reserve : Volume
        , rise : Volume
        , minimum : Volume
        , halve : Volume
        , tank : Volume
        }


details : Tank -> Plan
details { volume, start } =
    let
        reserve =
            Volume.scale 600 oneLiter

        rise =
            Volume.scale 250 oneLiter

        minimum =
            Volume.add reserve rise

        total =
            Pressure.volume volume start

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


view : Plan -> Html msg
view (Plan { reserve, rise, minimum, halve, tank }) =
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
                , Html.td [] [ Html.text <| Volume.toString reserve ]
                , Html.td [] [ Html.text <| Pressure.toString <| Pressure.scale (Volume.factor reserve tank) Pressure.oneBar ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text "Opstijging" ]
                , Html.td [] [ Html.text <| Volume.toString rise ]
                , Html.td [] [ Html.text <| Pressure.toString <| Pressure.scale (Volume.factor rise tank) Pressure.oneBar ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text "Minimum" ]
                , Html.td [] [ Html.text <| Volume.toString minimum ]
                , Html.td [] [ Html.text <| Pressure.toString <| Pressure.scale (Volume.factor minimum tank) Pressure.oneBar ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text "Omkeerdruk" ]
                , Html.td [] [ Html.text <| Volume.toString halve ]
                , Html.td [] [ Html.text <| Pressure.toString <| Pressure.scale (Volume.factor halve tank) Pressure.oneBar ]
                ]
            ]
        ]
