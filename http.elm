import Html exposing (Html, div, img, text, button, h2)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src)

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

type Msg = MorePls

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of 
    MorePls -> (model, Cmd.none)

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