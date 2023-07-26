module Plan exposing (Plan, plan, view)

import Air
import Html.Styled as Html exposing (Html)
import Measure.Depth exposing (Depth)
import Measure.Pressure exposing (Pressure)
import Measure.Time as Time
import Measure.Volume exposing (Volume)
import Plan.DiveTime as DiveTime


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
        , Html.span [] [ Html.text <| Measure.Depth.toString mdd ]
        , Html.label [] [ Html.text "MDT" ]
        , Html.span [] [ Html.text <| Time.toString <| DiveTime.mdt mdd ]
        , Html.label [] [ Html.text "Tank" ]
        , Html.span [] [ Html.text <| Measure.Volume.toString tank ]
        , Html.label [] [ Html.text "Start" ]
        , Html.span [] [ Html.text <| Measure.Pressure.toString start ]
        ]


body : Plan -> Html msg
body (Plan { tank, start }) =
    let
        configuration =
            { volume = tank, start = start }
    in
    Html.main_ []
        [ Air.plan configuration
        ]
