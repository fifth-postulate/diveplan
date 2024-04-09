module Measure.Sac exposing (Sac, litersPerMinute, toString)


type Sac
    = LitersPerMinute Int


litersPerMinute : Int -> Maybe Sac
litersPerMinute sac =
    if sac >= 0 then
        sac
            |> LitersPerMinute
            |> Just

    else
        Nothing


toString : Sac -> String
toString (LitersPerMinute sac) =
    String.fromInt sac ++ "l/min"
