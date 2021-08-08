module Page.Projects exposing (Data, Model, Msg, page)

import Browser.Navigation
import Css
import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import DataSource.Http
import Dict exposing (Dict)
import GithubRepo exposing (GithubRepo)
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr exposing (css)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Palette exposing (debugBorder)
import Path exposing (Path)
import ProjectNames exposing (projectNames)
import Shared
import Tailwind.Utilities as Tw
import View exposing (View)


projectRepos : DataSource (List GithubRepo)
projectRepos =
    DataSource.map GithubRepo.getRepos projectNames
        |> DataSource.resolve


getFilePath : String -> String
getFilePath name =
    "content/projects/" ++ name ++ ".md"


displayRepo : GithubRepo -> Html Msg
displayRepo repo =
    let
        repoName =
            GithubRepo.getName repo
    in
    let
        description =
            case GithubRepo.getDesc repo of
                Just desc ->
                    "Description: " ++ desc

                Nothing ->
                    "No Description"
    in
    let
        repoTitle =
            case GithubRepo.getLanguage repo of
                Just lang ->
                    lang ++ ": " ++ repoName

                Nothing ->
                    repoName
    in
    let
        lastUpdated =
            "Last updated: " ++ GithubRepo.getDate repo
    in
    let
        url =
            GithubRepo.getUrl repo
    in
    Html.div [ css [ Tw.grid, Tw.space_y_2, Tw.p_2, Tw.bg_gray_900, Tw.rounded ] ]
        [ Html.span [ css [ Tw.inline_flex ] ]
            [ Html.span [ css [ Tw.text_2xl, Tw.flex_grow ] ] [ Html.text repoTitle ]
            , Html.span
                [ css
                    [ Tw.text_gray_100
                    , Tw.bg_gray_800
                    , Tw.rounded
                    , Css.hover [ Tw.bg_gray_700 ]
                    ]
                ]
                [ Html.a
                    [ Attr.href ("/projects/" ++ repoName)
                    , css
                        [ Tw.text_gray_100
                        , Tw.text_lg
                        , Tw.m_1_dot_5
                        ]
                    ]
                    [ Html.text "More Details" ]
                ]
            ]
        , Html.span [ css [ Tw.text_gray_100 ] ] [ Html.text description ]
        , Html.span [ css [ Tw.text_gray_100 ] ] [ Html.text lastUpdated ]
        , Html.span []
            [ Html.a
                [ Attr.href url
                , css [ Tw.underline, Tw.text_gray_400, Css.hover [ Tw.text_gray_200 ] ]
                ]
                [ Html.text url ]
            ]
        ]



-- we will sort repos using GithubRepo.compare


displayRepos : List GithubRepo -> Html Msg
displayRepos repos =
    Html.div
        [ css
            [ Tw.grid
            , Tw.auto_cols_auto
            , Tw.flex_grow
            , Tw.space_y_2
            , Tw.px_4
            , Tw.py_2
            ]
        ]
    <|
        List.map
            displayRepo
        <|
            List.sortWith
                GithubRepo.compare
                repos


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


type alias Data =
    List GithubRepo


data : DataSource Data
data =
    projectRepos


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Just "https://fixedpoints.xyz"
        , siteName = "fixedpoints"
        , image =
            { url = Pages.Url.fromPath (Path.fromString "images/logo_white_with_text.svg")
            , alt = "fixedpoints logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Projects - Fixed Points"
        , locale = Nothing
        , title = "Projects - Fixed Points" -- metadata.title -- TODO
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Projects - Fixed Points"
    , body =
        [ Html.span [ css [ Tw.flex, Tw.justify_center, Tw.text_3xl ] ] [ Html.text "Personal Projects" ]
        , displayRepos static.data
        ]
    }
