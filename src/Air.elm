module Air exposing (Configuration, plan)

import Html exposing (Html)
import Pressure exposing (Pressure)
import Volume exposing (Volume, liter)


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
    , minimum: Volume
    , halve : Volume
    , tank : Volume
    }


details : Configuration -> Details
details { tank, start } =
    let
        reserve =
            liter 600 |> Maybe.withDefault Volume.oneLiter

        rise =
            liter 250 |> Maybe.withDefault Volume.oneLiter

        minimum =
            Volume.add reserve rise

        total =
            Pressure.volume tank start

        halve =
            Volume.add minimum total
                |> Volume.scale 0.5
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
