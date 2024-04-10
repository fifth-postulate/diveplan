module Measure.Sac exposing (Sac, litersPerMinute, toString)


type Sac
    = LitersPerMinute Float


litersPerMinute : Float -> Maybe Sac
litersPerMinute sac =
    if sac >= 0 then
        sac
            |> LitersPerMinute
            |> Just

    else
        Nothing


toString : Sac -> String
toString (LitersPerMinute sac) =
    (String.fromInt <| round <| sac) ++ "l/min"
