module Measure.Sac exposing (Sac, atDepth, averageBetweenSurfaceAnd, litersPerMinute, oneLiterPerMinute, times, toString)

import Measure.Depth exposing (Depth)
import Measure.Pressure as Pressure
import Measure.Time as Time exposing (Time)
import Measure.Volume as Volume exposing (Volume)


type Sac
    = LitersPerMinute Float


oneLiterPerMinute : Sac
oneLiterPerMinute =
    LitersPerMinute 1


litersPerMinute : Float -> Maybe Sac
litersPerMinute sac =
    if sac >= 0 then
        sac
            |> LitersPerMinute
            |> Just

    else
        Nothing


times : Time -> Sac -> Volume
times time (LitersPerMinute sac) =
    let
        factor =
            time
                |> Time.inMinutes
                |> (*) sac
    in
    Volume.scale factor Volume.oneLiter


atDepth : Depth -> Sac -> Sac
atDepth depth (LitersPerMinute sac) =
    let
        factor =
            depth
                |> Pressure.atDepth
                |> Pressure.inBar
    in
    LitersPerMinute (factor * sac)


averageBetweenSurfaceAnd : Depth -> Sac -> Sac
averageBetweenSurfaceAnd depth sac =
    let
        pressureAtSurface =
            Pressure.oneBar

        pressureAtDepth =
            Pressure.atDepth depth

        factor =
            Pressure.difference pressureAtDepth pressureAtSurface
                |> Pressure.scale 0.5
                |> Pressure.inBar
                |> (+) 1
    in
    sac
        |> scale factor


scale : Float -> Sac -> Sac
scale factor (LitersPerMinute sac) =
    LitersPerMinute (factor * sac)


toString : Sac -> String
toString (LitersPerMinute sac) =
    (String.fromInt <| round <| sac) ++ "l/min"
