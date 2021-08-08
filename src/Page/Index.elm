module Page.Index exposing (Data, Model, Msg, page)

-- import Element
-- import Element.Background as Background

import DataSource exposing (DataSource)
import DataSource.File
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr
import MdRendering
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


markdown : DataSource String
markdown =
    DataSource.File.bodyWithoutFrontmatter "content/index.md"


data : DataSource Data
data =
    markdown


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Just "https://fixedpoints.xyz"
        , siteName = "fixedpoints"
        , image =
            { url = Pages.Url.fromPath (Path.fromString "public/images/logo.svg")
            , alt = "fixedpoints logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Home - Fixed Points"
        , locale = Nothing
        , title = "Home - Fixed Points" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    String


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Fixed Points"
    , body =
        [ Html.div []
            [ MdRendering.renderMd static.data ]
        ]
    }
