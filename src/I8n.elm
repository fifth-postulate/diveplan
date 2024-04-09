module I8n exposing (Labels, en)


type alias Labels =
    { category : String
    , mdd : String
    , mdt : String
    , minimum : String
    , pressure : String
    , reserve : String
    , return : String
    , rise : String
    , sac : String
    , volume : String
    , waiting : String
    }


en : Labels
en =
    { category = "Category"
    , mdd = "MDD"
    , mdt = "MDT"
    , minimum = "Minimum"
    , pressure = "Pressure"
    , reserve = "Reserve"
    , return = "Return"
    , rise = "Rise"
    , sac = "SAC"
    , volume = "Volume"
    , waiting = "Waiting for correct input"
    }
