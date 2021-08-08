module GithubRepo exposing (GithubRepo, compare, getDate, getDesc, getLanguage, getName, getRepo, getRepos, getUrl, testCompare, testDecoder)

import DataSource exposing (DataSource)
import DataSource.Http
import OptimizedDecoder as Decode
import Pages.Secrets as Secrets


type alias Repo =
    { name : String
    , htmlUrl : String
    , description : Maybe String
    , language : Maybe String
    , updatedAt : UpdatedDate
    }


type alias GithubRepo =
    Repo


getDate : Repo -> String
getDate r =
    String.fromInt r.updatedAt.month
        ++ "/"
        ++ String.fromInt r.updatedAt.day
        ++ "/"
        ++ String.fromInt r.updatedAt.year


getName : Repo -> String
getName =
    .name


getUrl : Repo -> String
getUrl =
    .htmlUrl


getLanguage : Repo -> Maybe String
getLanguage =
    .language


getDesc : Repo -> Maybe String
getDesc =
    .description


repoDecoder : Decode.Decoder Repo
repoDecoder =
    Decode.map5 Repo
        (Decode.field "name" Decode.string)
        (Decode.field "html_url" Decode.string)
        (Decode.field "description" (Decode.nullable Decode.string))
        (Decode.field "language" (Decode.nullable Decode.string))
        (Decode.field "updated_at" updatedAtDecoder)



-- Create a DataSource containing a single repo


getRepo : String -> DataSource Repo
getRepo name =
    DataSource.Http.get (Secrets.succeed ("https://api.github.com/repos/rsulli55/" ++ name)) repoDecoder



-- Create a DataSource containing multiple repos


getRepos : List String -> List (DataSource Repo)
getRepos names =
    List.map getRepo names



-- we don't care about more granular details


type alias UpdatedDate =
    { year : Int
    , month : Int
    , day : Int
    }



-- helper for updatedAtDecoder


getIntFromListAt : Int -> List (Maybe Int) -> Int
getIntFromListAt n list =
    List.drop n list |> List.head |> Maybe.withDefault Nothing |> Maybe.withDefault 0



-- Github timestamps are in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ
-- https://docs.github.com/en/enterprise-server@3.0/rest/overview/resources-in-the-rest-api


dateCutoff : Int
dateCutoff =
    10


updatedAtDecoder : Decode.Decoder UpdatedDate
updatedAtDecoder =
    let
        maybeInts =
            Decode.string
                |> Decode.map (String.left dateCutoff)
                |> Decode.map (String.split "-")
                |> Decode.map (List.map String.toInt)
    in
    Decode.map3 UpdatedDate
        (Decode.map (getIntFromListAt 0) maybeInts)
        (Decode.map (getIntFromListAt 1) maybeInts)
        (Decode.map (getIntFromListAt 2) maybeInts)


compareDates : UpdatedDate -> UpdatedDate -> Order
compareDates d1 d2 =
    if d1.year < d2.year then
        LT

    else if (d1.year == d2.year) && (d1.month < d2.month) then
        LT

    else if (d1.year == d2.year) && (d1.month == d2.month) && (d1.day < d2.day) then
        LT

    else if (d1.year == d2.year) && (d1.month == d2.month) && (d1.day == d2.day) then
        EQ

    else
        GT



-- We want repos sorted in reverse chronological order


compare : Repo -> Repo -> Order
compare r1 r2 =
    compareDates r2.updatedAt r1.updatedAt


testDecoder =
    Decode.decodeString (Decode.field "updated_at" updatedAtDecoder) "{ \"updated_at\": \"2010-06-01:12341sszz\"}"


testCompare =
    (compareDates (UpdatedDate 2010 6 1) (UpdatedDate 2010 5 30) == GT)
        && (compareDates (UpdatedDate 2010 6 1) (UpdatedDate 2010 6 1) == EQ)
        && (compareDates (UpdatedDate 2010 6 1) (UpdatedDate 2011 5 30) == LT)
        && (compareDates (UpdatedDate 2009 6 1) (UpdatedDate 2010 5 30) == LT)
        && (compareDates (UpdatedDate 2010 6 1) (UpdatedDate 2010 6 30) == LT)
        && (compareDates (UpdatedDate 2010 6 10) (UpdatedDate 2010 6 9) == GT)
