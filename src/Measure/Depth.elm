module Measure.Depth exposing (Depth, compare, fiveMeters, inMeters, meter, toString, zeroMeters)

import Basics exposing (Order)


type Depth
    = Meter Float


zeroMeters : Depth
zeroMeters =
    Meter 0


fiveMeters : Depth
fiveMeters =
    Meter 5


meter : Float -> Maybe Depth
meter depth =
    if depth >= 0 then
        Just <| Meter depth

    else
        Nothing


inMeters : Depth -> Float
inMeters (Meter d) =
    d


toString : Depth -> String
toString depth =
    (String.fromInt <| round <| inMeters depth) ++ "m"


compare : Depth -> Depth -> Order
compare left right =
    Basics.compare (inMeters left) (inMeters right)
