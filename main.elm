import Html.Events exposing (..)
import Html exposing (Html, button, text, div)

type Msg = Reset | Increment Int | Decrement Int
type alias Model = { counter1: Int, counter2: Int }

main : Program Never Model Msg
main = Html.beginnerProgram { model = { counter1 = 0, counter2 = 0 }, view = view, update = update }

update : Msg -> Model -> Model
update msg model = 
  case msg of
    Reset -> { model | counter1 = 0, counter2 = 0 }

    Increment n -> 
      case n of 
        1 -> { model | counter1 = model.counter1 + 1 }
        2 -> { model | counter2 = model.counter2 + 1 }
        otherwise -> model
    
    Decrement n -> 
      case n of 
        1 -> { model | counter1 = model.counter1 - 1}
        2 -> { model | counter2 = model.counter2 - 1}
        otherwise -> model


view : Model -> Html Msg
view model =
  div [] 
    [button [onClick (Increment 1)] [text "inc1"]
    ,button [onClick (Decrement 1)] [text "dec1"]
    ,button [onClick (Increment 2)] [text "inc2"]
    ,button [onClick (Decrement 2)] [text "dec2"]
    ,button [onClick Reset] [text "reset"]
    ,text <| toString model.counter1
    ,text <| toString model.counter2
    ]
