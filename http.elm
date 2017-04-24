import Html exposing (Html, div, img, text, button, h2, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (src, type_, defaultValue)
import Http
import Json.Decode as Decode
import Tuple exposing (first, second)

main = Html.program {
    subscriptions = always Sub.none,
    init = init,
    update = update,
    view = view
  }

type alias Model = 
    {
      gifUrl: GifUrl,
      topic: String
    }

type alias FetchedData data = 
  {
    data: data,
    valid: Bool
  }

invalidate : FetchedData dataType -> FetchedData dataType
invalidate fetchedData = { fetchedData | valid = False }

validate : FetchedData dataType -> FetchedData dataType
validate fetchedData = { fetchedData | valid = True }

type alias GifUrl = FetchedData String

init : (Model, Cmd Msg)
init = 
  (
    {
      gifUrl = 
        { 
          data = "https://media.giphy.com/media/13CoXDiaCcCoyk/giphy.gif",
          valid = True 
        },
      topic = "cats"
    },
    Cmd.none
  )

type Msg = 
    MorePls
  | NewGif (Result Http.Error String)
  | SetTopic String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of 
    MorePls -> ({ model | gifUrl = invalidate model.gifUrl }, getGifUrl model.topic)

    NewGif (Ok url) -> ({ model | gifUrl = { data = url, valid = True } }, Cmd.none)

    NewGif (Err _) -> (model, Cmd.none)

    SetTopic topic -> ({ model | topic = topic }, Cmd.none)




getGifUrl : String -> Cmd Msg
getGifUrl topic = 
  let
    getUrl = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    gifDecoder = Decode.at ["data", "image_url"] Decode.string
    request = Http.get getUrl gifDecoder
  in
    Http.send NewGif request

imageView : GifUrl -> Html Msg
imageView gifUrl =
  case gifUrl.valid of 
    True -> 
      img [src gifUrl.data] []

    False ->
      img [src "https://media.giphy.com/media/UxREcFThpSEqk/giphy.gif"] []


view : Model -> Html Msg
view model =
  div [] 
    [
      input [type_ "text", defaultValue <| .topic <| first init, onInput SetTopic] [],
      imageView model.gifUrl,
      div [] [
        button [onClick MorePls]
          [
            text "MORE PLS"
          ]
      ]
    ]