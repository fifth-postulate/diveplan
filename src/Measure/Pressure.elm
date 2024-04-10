module Measure.Pressure exposing (Pressure, atDepth, bar, difference, inBar, oneBar, scale, toString, volume)

import Measure.Depth as Depth exposing (Depth)
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


atDepth : Depth -> Pressure
atDepth depth =
    let
        d =
            depth
                |> Depth.inMeters

        relative =
            d / 10.0

        absolute =
            1.0 + relative
    in
    Bar absolute


volume : Volume -> Pressure -> Volume
volume v (Bar f) =
    Volume.scale f v


difference : Pressure -> Pressure -> Pressure
difference (Bar left) (Bar right) =
    Bar (left - right)


scale : Float -> Pressure -> Pressure
scale f (Bar p) =
    Bar <| f * p


toString : Pressure -> String
toString p =
    (String.fromInt <| round <| inBar p) ++ "bar"
