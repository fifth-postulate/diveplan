module Measure.Volume exposing (Volume, add, factor, inLiters, liter, oneLiter, scale, toString, zeroLiter)


type Volume
    = Liter Float


zeroLiter : Volume
zeroLiter =
    Liter 0


oneLiter : Volume
oneLiter =
    Liter 1


liter : Float -> Maybe Volume
liter v =
    if v >= 0 then
        Just <| Liter v

    else
        Nothing


inLiters : Volume -> Float
inLiters (Liter v) =
    v


toString : Volume -> String
toString v =
    (String.fromInt <| round <| inLiters v) ++ "l"


add : Volume -> Volume -> Volume
add (Liter u) (Liter v) =
    Liter <| u + v


factor : Volume -> Volume -> Float
factor (Liter u) (Liter v) =
    u / v


scale : Float -> Volume -> Volume
scale f (Liter v) =
    Liter (f * v)
