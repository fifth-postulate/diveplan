module I8n exposing (Labels, en)


type alias Labels =
    { mdd : String
    , mdt : String
    , tank : String
    , start : String
    , category : String
    , volume : String
    , pressure : String
    , reserve : String
    , rise : String
    , minimum : String
    , return : String
    , waiting : String
    }


en : Labels
en =
    { mdd = "MDD"
    , mdt = "MDT"
    , tank = "Tank"
    , start = "Start"
    , category = "Category"
    , volume = "Volume"
    , pressure = "Pressure"
    , reserve = "Reserve"
    , rise = "Rise"
    , minimum = "Minimum"
    , return = "Return"
    , waiting = "Waiting for correct input"
    }
