module Volume exposing (Volume, add, factor, inLiters, liter, oneLiter, scale, toString)


type Volume
    = Liter Int


oneLiter : Volume
oneLiter =
    Liter 1


liter : Int -> Maybe Volume
liter v =
    if v >= 0 then
        Just <| Liter v

    else
        Nothing


inLiters : Volume -> Int
inLiters (Liter v) =
    v


toString : Volume -> String
toString v =
    (String.fromInt <| inLiters v) ++ "l"


add : Volume -> Volume -> Volume
add (Liter u) (Liter v) =
    Liter <| u + v


factor : Volume -> Volume -> Float
factor (Liter u) (Liter v) =
    toFloat u / toFloat v


scale : Float -> Volume -> Volume
scale f (Liter v) =
    Liter <| round <| f * toFloat v
