module Plan exposing (Plan, fromInput, plan, view)

import Air
import Css exposing (..)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attribute
import I8n exposing (Labels)
import Measure.Depth exposing (Depth)
import Measure.Pressure exposing (Pressure)
import Measure.Sac exposing (Sac)
import Measure.Time as Time
import Measure.Volume exposing (Volume)
import Plan.DiveTime as DiveTime


type Plan
    = Plan
        { mdd : Depth
        , tank : Volume
        , start : Pressure
        , sac : Sac
        }


fromInput :
    { depth : Maybe Depth
    , volume : Maybe Volume
    , pressure : Maybe Pressure
    , rate : Maybe Sac
    }
    -> Maybe Plan
fromInput input =
    case ( ( input.depth, input.volume ), ( input.pressure, input.rate ) ) of
        ( ( Just mdd, Just tank ), ( Just start, Just sac ) ) ->
            Just <| Plan { mdd = mdd, tank = tank, start = start, sac = sac }

        _ ->
            Nothing


plan : Depth -> Volume -> Pressure -> Sac -> Plan
plan mdd tank start sac =
    Plan { mdd = mdd, tank = tank, start = start, sac = sac }


view : Labels -> Plan -> Html msg
view labels p =
    Html.div [ Attribute.css [ marginTop <| px 5 ] ]
        [ header labels p
        , body labels p
        ]


header : Labels -> Plan -> Html msg
header labels (Plan { mdd, tank, start, sac }) =
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
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Measure.Depth.toString mdd ]
        , Html.label [ Attribute.css labelStyle ] [ Html.text labels.mdt ]
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Time.toString <| DiveTime.mdt mdd ]
        , Html.label [ Attribute.css labelStyle ] [ Html.text labels.tank ]
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Measure.Volume.toString tank ]
        , Html.label [ Attribute.css labelStyle ] [ Html.text labels.start ]
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Measure.Pressure.toString start ]
        , Html.label [ Attribute.css labelStyle ] [ Html.text labels.sac ]
        , Html.span [ Attribute.css spanStyle ] [ Html.text <| Measure.Sac.toString sac ]
        ]


body : Labels -> Plan -> Html msg
body labels (Plan { tank, start }) =
    let
        configuration =
            { volume = tank, start = start }
    in
    Html.main_ []
        [ Air.plan labels configuration
        ]
