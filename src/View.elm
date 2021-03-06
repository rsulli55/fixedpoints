module View exposing (View, map, placeholder)

import Html.Styled as Html exposing (Html)


type alias View msg =
    { title : String
    , body : List (Html msg)
    }


map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn doc =
    { title = doc.title
    , body = List.map (Html.map fn) doc.body
    }


placeholder : String -> View msg
placeholder moduleName =
    { title = "Fixed Points - " ++ moduleName
    , body = [ Html.text moduleName ]
    }



-- import Element exposing (Element)
-- type alias View msg =
--     { title : String
--     , body : List (Element msg)
--     }
-- map : (msg1 -> msg2) -> View msg1 -> View msg2
-- map fn doc =
--     { title = doc.title
--     , body = List.map (Element.map fn) doc.body
--     }
-- placeholder : String -> View msg
-- placeholder moduleName =
--     { title = "Fixed Points - " ++ moduleName
--     , body = [ Element.text moduleName ]
--     }
