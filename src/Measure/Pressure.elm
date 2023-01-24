module Measure.Pressure exposing (Pressure, bar, inBar, oneBar, scale, toString, volume)

import Measure.Volume as Volume exposing (Volume)


type Pressure
    = Bar Int


oneBar : Pressure
oneBar =
    Bar 1


bar : Int -> Maybe Pressure
bar p =
    if p >= 0 then
        Just <| Bar p

    else
        Nothing


inBar : Pressure -> Int
inBar (Bar p) =
    p


volume : Volume -> Pressure -> Volume
volume v (Bar f) =
    Volume.scale (toFloat f) v


scale : Float -> Pressure -> Pressure
scale f (Bar p) =
    Bar <| round <| f * toFloat p


toString : Pressure -> String
toString p =
    (String.fromInt <| inBar p) ++ "bar"
