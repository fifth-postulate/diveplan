module Plan exposing (Plan, plan, view)

import Air
import Depth exposing (Depth)
import Html exposing (Html)
import Pressure exposing (Pressure)
import Time
import Volume exposing (Volume)


type Plan
    = Plan
        { mdd : Depth
        , tank : Volume
        , start : Pressure
        }


plan : Depth -> Volume -> Pressure -> Plan
plan mdd tank start =
    Plan { mdd = mdd, tank = tank, start = start }


view : Plan -> Html msg
view p =
    Html.div []
        [ header p
        , body p
        ]


header : Plan -> Html msg
header (Plan { mdd, tank, start }) =
    Html.header []
        [ Html.label [] [ Html.text "MDD" ]
        , Html.span [] [ Html.text <| Depth.toString mdd ]
        , Html.label [] [ Html.text "MDT" ]
        , Html.span [] [ Html.text <| Time.toString <| Time.mdt mdd ]
        , Html.label [] [ Html.text "tank" ]
        , Html.span [] [ Html.text <| Volume.toString tank ]
        , Html.label [] [ Html.text "start" ]
        , Html.span [] [ Html.text <| Pressure.toString start ]
        ]


body : Plan -> Html msg
body (Plan { tank, start }) =
    let
        configuration =
            { tank = tank, start = start }
    in
    Html.main_ []
        [ Air.plan configuration
        ]
