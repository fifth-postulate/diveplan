module Plan exposing (Plan, from, tryFrom, view)

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
import Plan.Tank as Tank exposing (Tank)


type Plan
    = Plan
        { mdd : Depth
        , tank : Tank
        , sac : Sac
        }


mddOf : Plan -> Depth
mddOf (Plan { mdd }) =
    mdd


tankOf : Plan -> Tank
tankOf (Plan { tank }) =
    tank


sacOf : Plan -> Sac
sacOf (Plan { sac }) =
    sac


tryFrom :
    { depth : Maybe Depth
    , tank : Maybe Tank
    , rate : Maybe Sac
    }
    -> Maybe Plan
tryFrom { depth, tank, rate } =
    case ( depth, tank, rate ) of
        ( Just mdd, Just equipment, Just sac ) ->
            from mdd equipment sac
                |> Just

        _ ->
            Nothing


from : Depth -> Tank -> Sac -> Plan
from mdd tank sac =
    Plan { mdd = mdd, tank = tank, sac = sac }


view : Labels -> Plan -> Html msg
view labels plan =
    Html.div [ Attribute.css [ marginTop <| px 5 ] ]
        [ header labels plan
        , body labels plan
        ]


header : Labels -> Plan -> Html msg
header labels plan =
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
body labels aPlan =
    let
        equipment =
            tankOf aPlan

        configuration =
            { volume = Tank.volume equipment, start = Tank.pressure equipment }
    in
    Html.main_ []
        [ Air.plan labels configuration
        ]
