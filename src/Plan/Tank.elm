module Plan.Tank exposing (Tank, from, pressure, tryFrom, volume)

import Measure.Pressure exposing (Pressure)
import Measure.Volume exposing (Volume)


type Tank
    = Tank
        { volume : Volume
        , pressure : Pressure
        }


from : Volume -> Pressure -> Tank
from v p =
    Tank { volume = v, pressure = p }


tryFrom : Maybe Volume -> Maybe Pressure -> Maybe Tank
tryFrom tankVolume tankPressure =
    case ( tankVolume, tankPressure ) of
        ( Just v, Just p ) ->
            from v p
                |> Just

        _ ->
            Nothing


volume : Tank -> Volume
volume (Tank tank) =
    tank.volume


pressure : Tank -> Pressure
pressure (Tank tank) =
    tank.pressure
