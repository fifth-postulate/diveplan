module Plan.Input exposing (Input, from, mddOf, sacOf, tankOf, tryFrom)

import Css exposing (..)
import Measure.Depth exposing (Depth)
import Measure.Sac exposing (Sac)
import Plan.Tank exposing (Tank)


type Input
    = Configuration
        { mdd : Depth
        , tank : Tank
        , sac : Sac
        }


mddOf : Input -> Depth
mddOf (Configuration { mdd }) =
    mdd


tankOf : Input -> Tank
tankOf (Configuration { tank }) =
    tank


sacOf : Input -> Sac
sacOf (Configuration { sac }) =
    sac


tryFrom :
    { depth : Maybe Depth
    , tank : Maybe Tank
    , rate : Maybe Sac
    }
    -> Maybe Input
tryFrom { depth, tank, rate } =
    case ( depth, tank, rate ) of
        ( Just mdd, Just equipment, Just sac ) ->
            from mdd equipment sac
                |> Just

        _ ->
            Nothing


from : Depth -> Tank -> Sac -> Input
from mdd tank sac =
    Configuration { mdd = mdd, tank = tank, sac = sac }
