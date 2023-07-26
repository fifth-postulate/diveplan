module Plan exposing (Plan, plan, view)

import Air
import Css exposing (..)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attribute
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
    Html.div [ Attribute.css [ marginTop <| px 5 ] ]
        [ header p
        , body p
        ]


header : Plan -> Html msg
header (Plan { mdd, tank, start }) =
    let
        labelStyle : List Style
        labelStyle =
            [ after [ property "content" "':'" ] ]

        spanStyle : List Style
        spanStyle =
            [ marginLeft <| px 3, marginRight <| px 5 ]
    in
    Html.header []
        [ Html.label [ Attribute.css labelStyle ] [ Html.text "MDD" ]
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Measure.Depth.toString mdd ]
        , Html.label [ Attribute.css labelStyle ] [ Html.text "MDT" ]
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Time.toString <| DiveTime.mdt mdd ]
        , Html.label [ Attribute.css labelStyle ] [ Html.text "Tank" ]
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Measure.Volume.toString tank ]
        , Html.label [ Attribute.css labelStyle ] [ Html.text "Start" ]
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Measure.Pressure.toString start ]
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
