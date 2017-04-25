import Html exposing (Html)
import Html.Attributes exposing (style)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)


type alias Model = Time

type Msg = Tick Time

init : (Model, Cmd Msg)
init = (0, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of 
    Tick newTime -> (newTime, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = 
  Time.every second Tick

view : Model -> Html Msg
view model = 
  let
    minutes = Time.inMinutes model
    angle = minutes - 0.25 |> turns
    hand = {
      x = toString <| 50 + 40 * cos angle,
      y = toString <| 50 + 40 * sin angle
    }
  in
    svg [viewBox "0 0 100 100", width "100px"] [
      circle [cx "50", cy "50", r "45", fill "lightblue"] [],
      line [
        x1 "50", 
        y1 "50", 
        x2 "90",
        y2 "50",
        stroke "dimgrey", 
        Html.Attributes.style [
          ("transition", "transform 1s"), 
          ("transform", "rotate(" ++ (toString angle) ++ "rad)"),
          ("transform-origin", "left center")
        ]
      ] []
    ]


main = 
  Html.program {
    init = init,
    subscriptions = subscriptions,
    update = update,
    view = view
  } 
