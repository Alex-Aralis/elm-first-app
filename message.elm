import Html exposing (Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, on, keyCode)
import WebSocket
import Json.Decode
import Json.Decode exposing (andThen)

type alias Model = {
  input: String,
  messages: List String
}

type Action = 
    Receive String
  | SetInput String
  | Send

wsUrl : String
wsUrl = "ws://echo.websocket.org"

subscriptions : Model -> Sub Action
subscriptions model =
  WebSocket.listen wsUrl Receive


update : Action -> Model -> (Model, Cmd Action)
update action model = case action of
  SetInput input -> ({ model | input = input }, Cmd.none)
  Send -> ({ model | input = "" }, WebSocket.send wsUrl model.input)
  Receive message -> ({ model | messages = message :: model.messages }, Cmd.none)


view : Model -> Html Action
view model = 
  div [] [
    List.map messageView model.messages |> List.reverse |> div []
    ,
    div [] [
      input [type_ "text", onEnter Send, onInput SetInput, value model.input] []
    ]
  ]

messageView : String -> Html Action
messageView message = 
  div [] [
    text message
  ]

onEnter : Action -> Html.Attribute Action
onEnter action =
  let 
    isEnter code = if code == 13 then Json.Decode.succeed action else Json.Decode.fail "not Enter"
  in
    keyCode |> andThen isEnter |> on "keydown"

init : (Model, Cmd Action)
init = 
  ({
    messages = [],
    input = ""
  }, Cmd.none)

main = 
  Html.program {
    subscriptions = subscriptions,
    update = update,
    view = view,
    init = init
  }