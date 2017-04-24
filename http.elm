import Html exposing (Html, div, img, text, button, h2)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src)
import Http
import Json.Decode as Decode

main = Html.program {
    subscriptions = always Sub.none,
    init = init,
    update = update,
    view = view
  }

type alias Model = 
    {
      gifUrl: String,
      topic: String
    }


init : (Model, Cmd Msg)
init = 
  (
    {
      gifUrl = "https://media.giphy.com/media/13CoXDiaCcCoyk/giphy.gif",
      topic = "cats"
    },
    Cmd.none
  )

type Msg = 
    MorePls
  | NewGif (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of 
    MorePls -> (model, getGifUrl model.topic)

    NewGif (Ok url) -> ({ model | gifUrl = url }, Cmd.none)

    NewGif (Err _) -> (model, Cmd.none)


getGifUrl : String -> Cmd Msg
getGifUrl topic = 
  let
    getUrl = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    gifDecoder = Decode.at ["data", "image_url"] Decode.string
    request = Http.get getUrl gifDecoder
  in
    Http.send NewGif request

view : Model -> Html Msg
view model =
  div [] 
    [
      h2 []
        [
          text model.topic
        ],
      img [src model.gifUrl]
        [
          text model.gifUrl
        ],
      div [] [
        button [onClick MorePls]
          [
            text "MORE PLS"
          ]
      ]
    ]