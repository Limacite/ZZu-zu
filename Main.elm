module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import File exposing (File)
import File.Select as Select
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Time


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- Model


type alias Model =
    { input : String
    , inputImg : Maybe String
    , memos : List Memo
    , zone : Time.Zone
    , time : Time.Posix
    , viewPage : Int
    }


type alias Memo =
    { date : String
    , text : String
    , img : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" Nothing [] Time.utc (Time.millisToPosix 0) 1
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE


type Msg
    = Input String
    | ImgSelected File
    | ImgLoaded String
    | ImgRequested
    | Submit
    | AdjustTimeZone Time.Zone
    | Tick Time.Posix
    | PageSelect Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input input ->
            ( { model | input = input }
            , Cmd.none
            )

        ImgRequested ->
            ( model
            , Select.file [ "image/jpeg", "image/png" ] ImgSelected
            )

        ImgSelected img ->
            ( model, Task.perform ImgLoaded <| File.toUrl img )

        ImgLoaded content ->
            ( { model | inputImg = Just content }
            , Cmd.none
            )

        Submit ->
            let
                toYear =
                    String.fromInt (Time.toYear model.zone model.time)

                toMonth =
                    toStringMonth (Time.toMonth model.zone model.time)

                toDay =
                    String.fromInt (Time.toDay model.zone model.time)

                newMemo =
                    { date = toYear ++ "-" ++ toMonth ++ "-" ++ toDay
                    , text = model.input
                    , img =
                        case model.inputImg of
                            Nothing ->
                                ""

                            Just content ->
                                content
                    }
            in
            ( { model | input = "", inputImg = Nothing, memos = newMemo :: model.memos }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }, Cmd.none )

        Tick newTime ->
            ( { model | time = newTime }, Cmd.none )

        PageSelect number ->
            ( { model | viewPage = number }, Cmd.none )


toStringMonth : Time.Month -> String
toStringMonth month =
    case month of
        Time.Jan ->
            "01"

        Time.Feb ->
            "02"

        Time.Mar ->
            "03"

        Time.Apr ->
            "04"

        Time.May ->
            "05"

        Time.Jun ->
            "06"

        Time.Jul ->
            "07"

        Time.Aug ->
            "08"

        Time.Sep ->
            "09"

        Time.Oct ->
            "10"

        Time.Nov ->
            "11"

        Time.Dec ->
            "12"



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [ style "width" "30%", style "float" "left" ]
            [ ul [ style "list-style-type" "none", style "width" "100%" ]
                [ li [ onClick (PageSelect 1) ] [ text "投稿" ]
                , li [ onClick (PageSelect 2) ] [ text "地図" ]
                ]
            ]
        , div [ style "width" "50%", style "margin" "0 auto", style "float" "left" ]
            [ div [ style "height" "70px" ] []
            , hr [ style "size" "3px", style "color" "black" ] []
            , timeline model
            , mapmode model
            ]
        ]


viewMemo : Memo -> Html Msg
viewMemo memo =
    li [ style "border" "solid 1px #000000", style "border-top" "none" ]
        [ div [] [ text memo.text ]
        , div [] [ img [ style "height" "150px", src memo.img, hidden (String.length memo.img < 1) ] [] ]
        , div [ style "text-align" "right" ] [ text memo.date ]
        ]


timeline : Model -> Html Msg
timeline model =
    div [ hidden (model.viewPage /= 1) ]
        [ postForm model
        , ul [ style "list-style-type" "none", style "margin-left" "0px", style "padding-left" "0px", style "border-top" "solid 1px #000000", style "width" "100%", style "height" "400px", style "overflow-y" "scroll", hidden (List.length model.memos < 1) ] (List.map viewMemo model.memos)
        ]


postForm : Model -> Html Msg
postForm model =
    Html.form [ onSubmit Submit ]
        [ textarea [ value model.input, onInput Input, style "width" "99%", style "height" "100px", style "resize" "none", style "margin-left" "0px", style "padding" "0px" ] []
        , br [] []
        , label [ onClick ImgRequested, style "border" "solid 1px #000000" ] [ text "画像を選択" ]
        , div [ hidden (model.inputImg == Nothing) ]
            [ case model.inputImg of
                Nothing ->
                    text ""

                Just content ->
                    img [ src content, style "height" "150px" ] []
            ]
        , button
            [ disabled (String.length model.input < 1 && model.inputImg == Nothing) ]
            [ text "Submit" ]
        ]


mapmode : Model -> Html Msg
mapmode model =
    div [ hidden (model.viewPage /= 2) ]
        [ input [] []
        , button [] [ text "検索" ]
        , div [ id "mapArea", style "width" "100%", style "height" "500px", style "border" "solid 1px #000000" ] []
        ]
