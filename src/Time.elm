module Time exposing (mdt)

import Basics
import Measure.Depth as Depth exposing (Depth, meter)
import Measure.Time as Time exposing (Time, minutes)


table : List ( Depth, Time )
table =
    [ ( meter 54, minutes 5 )
    , ( meter 51, minutes 6 )
    , ( meter 48, minutes 6 )
    , ( meter 45, minutes 7 )
    , ( meter 42, minutes 7 )
    , ( meter 39, minutes 8 )
    , ( meter 36, minutes 10 )
    , ( meter 33, minutes 12 )
    , ( meter 30, minutes 15 )
    , ( meter 27, minutes 20 )
    , ( meter 24, minutes 25 )
    , ( meter 21, minutes 35 )
    , ( meter 18, minutes 50 )
    , ( meter 15, minutes 75 )
    , ( meter 12, minutes 150 )
    , ( meter 9, minutes 300 )
    ]
        |> List.map (Tuple.mapBoth (Maybe.withDefault Depth.zero) (Maybe.withDefault Time.zero))


mdt : Depth -> Time
mdt depth =
    let
        shallowerDepths ( d, _ ) =
            case Depth.compare d depth of
                Basics.GT ->
                    False

                Basics.EQ ->
                    True

                Basics.LT ->
                    True
    in
    table
        |> List.filter shallowerDepths
        |> List.head
        |> Maybe.map Tuple.second
        |> Maybe.withDefault (Time.times 300 Time.oneMinute)
