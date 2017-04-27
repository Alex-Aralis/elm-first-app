import Html exposing (..)
import Html.Attributes exposing (..)
import Mouse exposing (..)

type alias Model = 
  {
    pos: Position,
    clicks: List Position
  }

type Action = 
    SetPos Position 
  | Click Position

init : (Model, Cmd Action)
init = 
  ({
    pos = Position 0 0,
    clicks = []
  }, Cmd.none)

subscriptions : Model -> Sub Action
subscriptions model = 
  Sub.batch [moves SetPos, downs Click]

update : Action -> Model -> (Model, Cmd Action)
update action model = case action of
  Click p -> 
    ({ model | clicks = p :: model.clicks }, Cmd.none)

  SetPos p -> 
    ({ model | pos = p }, Cmd.none)

view : Model -> Html Action
view model =
  div [] [
    posView model.pos,
    mouseView model.pos,
    clicksView model.clicks
  ]


posView : Position -> Html action
posView pos = 
  div [] [
    text <| toString pos
  ]

mouseView : Position -> Html action
mouseView pos = 
  let 
    toPx v = 
      (toString v) ++ "px"

    w = 50
    h = 50

    locSty = 
      [("position", "fixed"), ("left", toPx <| pos.x - w//2), ("top", toPx <| pos.y - h//2)]
    
    colorSty = 
      [("background", "orange")]

    sizeSty = 
      [("width", toPx w), ("height", toPx h)]

    sty = style <| locSty ++ colorSty ++ sizeSty
  in
    div [sty] []

clicksView : List Position -> Html action
clicksView posList =
  let

    clickView pos =
      let
        toPx v = 
          (toString v) ++ "px"

        location = 
          [("position", "fixed"), ("left", toPx pos.x), ("top", toPx pos.y)]

        color = 
          [("background", "cyan")]
        
        sty = style <| location ++ color
      in 
        div [sty] [text <| toString pos]
  in
    posList |> List.map clickView |> div []


main = 
  Html.program {
    init = init,
    update = update,
    view = view,
    subscriptions = subscriptions
  }
