module Plan exposing (Plan, from, view)

import Air
import Css exposing (..)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attribute
import I8n exposing (Labels)
import Measure.Depth exposing (Depth)
import Measure.Pressure
import Measure.Sac exposing (Sac)
import Measure.Time as Time
import Measure.Volume
import Plan.DiveTime as DiveTime
import Plan.Input as Input exposing (Input, mddOf, sacOf, tankOf)
import Plan.Tank as Tank exposing (Tank)


type Plan
    = Plan Input


from : Input -> Plan
from input =
    Plan input


view : Labels -> Plan -> Html msg
view labels plan =
    Html.div [ Attribute.css [ marginTop <| px 5 ] ]
        [ header labels plan
        , body labels plan
        ]


header : Labels -> Plan -> Html msg
header labels (Plan plan) =
    let
        labelStyle : List Style
        labelStyle =
            [ after [ property "content" "':'" ] ]

        spanStyle : List Style
        spanStyle =
            [ marginLeft <| px 3, marginRight <| px 5 ]
    in
    Html.header []
        [ Html.label [ Attribute.css labelStyle ] [ Html.text labels.mdd ]
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Measure.Depth.toString <| mddOf plan ]
        , Html.label [ Attribute.css labelStyle ] [ Html.text labels.mdt ]
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Time.toString <| DiveTime.mdt <| mddOf plan ]
        , Html.label [ Attribute.css labelStyle ] [ Html.text labels.tank ]
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Measure.Volume.toString <| Tank.volume <| tankOf plan ]
        , Html.label [ Attribute.css labelStyle ] [ Html.text labels.start ]
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Measure.Pressure.toString <| Tank.pressure <| tankOf plan ]
        , Html.label [ Attribute.css labelStyle ] [ Html.text labels.sac ]
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Measure.Sac.toString <| sacOf plan ]
        ]


body : Labels -> Plan -> Html msg
body labels (Plan input) =
    Html.main_ []
        [ Air.plan labels input
        ]
