module Measure.Time exposing (Time, inMinutes, minutes, oneMinute, times, toString, zero)


type Time
    = Minute Int


zero : Time
zero =
    Minute 0


oneMinute : Time
oneMinute =
    Minute 1


minutes : Int -> Maybe Time
minutes t =
    if t >= 0 then
        Just <| Minute t

    else
        Nothing


inMinutes : Time -> Int
inMinutes (Minute t) =
    t


toString : Time -> String
toString t =
    String.fromInt (inMinutes t) ++ "min"


times : Int -> Time -> Time
times factor (Minute t) =
    Minute (factor * t)
