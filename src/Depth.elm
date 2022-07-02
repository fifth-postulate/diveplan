module Depth exposing (Depth, compare, inMeters, meter, toString, zero)

import Basics exposing (Order)


type Depth
    = Meter Int


zero : Depth
zero =
    Meter 0


meter : Int -> Maybe Depth
meter depth =
    if depth >= 0 then
        Just <| Meter depth

    else
        Nothing


inMeters : Depth -> Int
inMeters (Meter d) =
    d


toString : Depth -> String
toString depth =
    (String.fromInt <| inMeters depth) ++ "m"


compare : Depth -> Depth -> Order
compare left right =
    Basics.compare (inMeters left) (inMeters right)
