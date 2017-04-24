import Html exposing (Html, div, img, text, button, h2, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (src, type_, defaultValue, style)
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
      topic: String,
      errorMessage: ErrorMessage
    }

type alias ErrorMessage = {
  display: Bool,
  message: String
}


type alias FetchedData data = 
  {
    data: data,
    valid: Bool
  }

type alias GifUrl = FetchedData String

invalidate : FetchedData dataType -> FetchedData dataType
invalidate fetchedData = { fetchedData | valid = False }

validate : FetchedData dataType -> FetchedData dataType
validate fetchedData = { fetchedData | valid = True }


init : (Model, Cmd Msg)
init = 
  (
    {
      gifUrl = { 
        data = "https://media.giphy.com/media/13CoXDiaCcCoyk/giphy.gif",
        valid = True 
      },
      topic = "cats",
      errorMessage = {
        display = False,
        message = "Error"
      }
    },
    Cmd.none
  )

type Msg = 
    MorePls
  | NewGif (Result Http.Error String)
  | SetTopic String
  | ClearError

clearMessage : ErrorMessage -> ErrorMessage
clearMessage message =
  { message | display = False }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of 
    MorePls -> ({ model | gifUrl = invalidate model.gifUrl }, getGifUrl model.topic)

    NewGif (Ok url) -> ({ model | gifUrl = { data = url, valid = True } }, Cmd.none)

    NewGif (Err _) -> ({ model | gifUrl = validate model.gifUrl, errorMessage = { display = True, message = "Fetch Failed" } }, Cmd.none)

    SetTopic topic -> ({ model | topic = topic }, Cmd.none)

    ClearError -> ({ model | errorMessage = clearMessage model.errorMessage }, Cmd.none)



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

errorView : ErrorMessage -> Html Msg
errorView { display, message } =
  let
    positionStyle = [
      ("position", "fixed"),
      ("left", "0"),
      ("right", "0"),
      ("top", "0"),
      ("bottom", "0")
    ]
    innerBoxHeight = "100px"
    displayStyle = [
      ("display", if display then "grid" else "none"),
      ("grid-template-columns", "auto 200px auto"),
      ("grid-template-rows", "auto " ++ innerBoxHeight ++ " auto")
    ]
    redStyle = [
      ("background", "red")
    ]
    gridCenter = [
      ("grid-column", "2 / 3"),
      ("grid-row", "2 / 3")
    ]
    centerText = [
      ("text-align", "center"),
      ("vertical-align", "middle"),
      ("line-height", innerBoxHeight)
    ]
    innerBoxStyle = redStyle ++ gridCenter ++ centerText
    outerBoxStyle = positionStyle ++ displayStyle

  in
    div [style outerBoxStyle] [
      div [style innerBoxStyle, onClick ClearError] [
        text message
      ]
    ]

topicField : String -> Html Msg
topicField topic =
  div [] [input [type_ "text", defaultValue topic, onInput SetTopic] []]

view : Model -> Html Msg
view model =
  div [] 
    [
      topicField <| .topic <| first init,
      imageView model.gifUrl,
      div [] [
        button [onClick MorePls]
          [
            text "MORE PLS"
          ]
      ],
      errorView model.errorMessage
    ]