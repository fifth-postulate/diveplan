module I8n exposing (Labels, en)


type alias Labels =
    { category : String
    , mdd : String
    , mdt : String
    , minimum : String
    , pressure : String
    , reserve : String
    , return : String
    , ascend : String
    , sac : String
    , stop : String
    , subCategory : String
    , total : String
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
    , ascend = "Ascend"
    , sac = "SAC"
    , stop = "Safety stop"
    , subCategory = "Sub-category"
    , total = "Total"
    , volume = "Volume"
    , waiting = "Waiting for correct input"
    }
