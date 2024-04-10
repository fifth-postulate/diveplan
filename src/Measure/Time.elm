module Measure.Time exposing (Time, inMinutes, minutes, oneMinute, times, toString, zero)


type Time
    = Minute Float


zero : Time
zero =
    Minute 0


oneMinute : Time
oneMinute =
    Minute 1


minutes : Float -> Maybe Time
minutes t =
    if t >= 0 then
        Just <| Minute t

    else
        Nothing


inMinutes : Time -> Float
inMinutes (Minute t) =
    t


toString : Time -> String
toString t =
    (String.fromInt <| round <| inMinutes t) ++ "min"


times : Float -> Time -> Time
times factor (Minute t) =
    Minute (factor * t)
