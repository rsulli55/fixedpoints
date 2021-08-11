module Page.Projects.Name_ exposing (Data, Model, Msg, page)

import Css
import DataSource exposing (DataSource)
import DataSource.File
import Head
import Head.Seo as Seo
import Html.Styled as Html
import Html.Styled.Attributes as Attr exposing (css)
import MdRendering
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import ProjectNames exposing (projectNames)
import Shared
import Tailwind.Utilities as Tw
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { name : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    DataSource.map (List.map (\name -> RouteParams name)) projectNames


getProjectMarkdown : String -> DataSource String
getProjectMarkdown name =
    DataSource.File.bodyWithoutFrontmatter ("content/projects/" ++ name ++ ".md")


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map2 Data
        (DataSource.succeed routeParams.name)
        (getProjectMarkdown routeParams.name)


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Just "https://fixedpoints.xyz"
        , siteName = "fixedpoints"
        , image =
            { url = Pages.Url.fromPath (Path.fromString "/images/logo_white_with_text.svg")
            , alt = "fixedpoints logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = static.data.route ++ " - Fixed Points"
        , locale = Nothing
        , title = static.data.route ++ " - Fixed Points"
        }
        |> Seo.website


type alias Data =
    { route : String, markdown : String }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.route ++ " - Fixed Points"
    , body =
        [ MdRendering.renderMd static.data.markdown ]
    }
