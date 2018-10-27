port module Thumbs exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)


-- MODEL


type alias Model =
    { ups : Int
    , downs : Int
    , comments : List String
    }

init: () -> (Model, Cmd Msg)
init _ = 
    (Model 0 0 [],Cmd.none)

-- UPDATE


type Msg
    = Up
    | Down
    | NewComment String


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Up ->
            ( { model | ups = model.ups + 1 }, thumbed model )

        Down ->
            ( { model | downs = model.downs + 1 }, thumbed model )

        NewComment comment ->
            ( { model | comments = comment :: model.comments }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Down ]
            [ text ((String.fromInt model.downs) ++ " 👎") ]
        , button [ onClick Up ]
            [ text ((String.fromInt model.ups) ++ " 👍") ]
        , commentList model.comments
        ]


commentItem : String -> Html Msg
commentItem comment =
    li [] [ text comment ]


commentList : List String -> Html Msg
commentList comments =
    ul [ id "comments" ] (List.map commentItem comments)



-- PORTS


port newComment : (String -> msg) -> Sub msg


port thumbed : Model -> Cmd msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    newComment NewComment



main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
