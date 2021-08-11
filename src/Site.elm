module Site exposing (config)

import DataSource
import Head
import MimeType
import Pages.Manifest as Manifest
import Pages.Url
import Path
import Route
import SiteConfig exposing (SiteConfig)


type alias Data =
    ()


config : SiteConfig Data
config =
    { data = data
    , canonicalUrl = "https://fixedpoints.xyz"
    , manifest = manifest
    , head = head
    }


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


head : Data -> List Head.Tag
head static =
    [ Head.icon [ ( 32, 32 ) ] MimeType.Png (Pages.Url.fromPath <| Path.fromString "/images/logo_white_32.png")
    , Head.icon [ ( 16, 16 ) ] MimeType.Png (Pages.Url.fromPath <| Path.fromString "/images/logo_white_16.png")
    , Head.appleTouchIcon (Just 180) (Pages.Url.fromPath <| Path.fromString "/images/logo_white_180.png")
    , Head.appleTouchIcon (Just 192) (Pages.Url.fromPath <| Path.fromString "/images/logo_white_192.png")
    , Head.sitemapLink "/sitemap.xml"
    ]


manifest : Data -> Manifest.Config
manifest static =
    Manifest.init
        { name = "Fixed Points"
        , description = "Fixed Points - Ryan Sullivant's website"
        , startUrl = Route.Index |> Route.toPath
        , icons =
            [ icon MimeType.Png 192
            , icon MimeType.Png 512
            ]
        }


icon :
    MimeType.MimeImage
    -> Int
    -> Manifest.Icon
icon format width =
    { src = Pages.Url.fromPath <| Path.fromString ("/images/logo_white_" ++ String.fromInt width ++ ".png")
    , sizes = [ ( width, width ) ]
    , mimeType = format |> Just
    , purposes = [ Manifest.IconPurposeAny, Manifest.IconPurposeMaskable ]
    }
