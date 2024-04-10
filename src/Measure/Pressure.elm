module Measure.Pressure exposing (Pressure, bar, inBar, oneBar, scale, toString, volume)

import Measure.Volume as Volume exposing (Volume)


type Pressure
    = Bar Float


oneBar : Pressure
oneBar =
    Bar 1.0


bar : Float -> Maybe Pressure
bar p =
    if p >= 0 then
        Just <| Bar p

    else
        Nothing


inBar : Pressure -> Float
inBar (Bar p) =
    p


volume : Volume -> Pressure -> Volume
volume v (Bar f) =
    Volume.scale f v


scale : Float -> Pressure -> Pressure
scale f (Bar p) =
    Bar <| f * p


toString : Pressure -> String
toString p =
    (String.fromInt <| round <| inBar p) ++ "bar"
