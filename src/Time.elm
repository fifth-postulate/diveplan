module Time exposing (Time, inMinutes, mdt, toString)

import Basics
import Depth exposing (Depth, meter)


type Time
    = Minute Int


table : List ( Depth, Time )
table =
    [ ( meter 54, Minute 5 )
    , ( meter 51, Minute 6 )
    , ( meter 48, Minute 6 )
    , ( meter 45, Minute 7 )
    , ( meter 42, Minute 7 )
    , ( meter 39, Minute 8 )
    , ( meter 36, Minute 10 )
    , ( meter 33, Minute 12 )
    , ( meter 30, Minute 15 )
    , ( meter 27, Minute 20 )
    , ( meter 24, Minute 25 )
    , ( meter 21, Minute 35 )
    , ( meter 18, Minute 50 )
    , ( meter 15, Minute 75 )
    , ( meter 12, Minute 150 )
    , ( meter 9, Minute 300 )
    ]
        |> List.map (Tuple.mapFirst (Maybe.withDefault Depth.zero))


mdt : Depth -> Time
mdt depth =
    let
        shallowerDepths ( d, _ ) =
            case Depth.compare d depth of
                Basics.GT -> False
                Basics.EQ -> True
                Basics.LT -> True
    in
    table
        |> List.filter shallowerDepths
        |> List.head
        |> Maybe.map Tuple.second
        |> Maybe.withDefault (Minute 300)


inMinutes : Time -> Int
inMinutes (Minute t) =
    t


toString : Time -> String
toString t =
    String.fromInt (inMinutes t) ++ "min"
