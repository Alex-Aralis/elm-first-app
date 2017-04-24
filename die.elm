import Html.Events exposing (onClick)
import Html.Attributes exposing (src, style)
import Html exposing (Html, div, text, button, img)
import Random

main : Program Never Model Msg
main = 
  Html.program
    {
      init = init,
      view = view,
      update = update,
      subscriptions = always Sub.none
    }

type alias Model = 
  { 
    dieFace: Int
  }

type Msg = Roll | NewFace Int

size : a -> b -> Html.Attribute msg
size x y = 
  let
    toPx n = (toString n) ++ "px"
  in
    style [("height", toPx y), ("width", toPx x)]

view : Model -> Html Msg
view model = 
  div [] [
    div [] [
      img [src <| faceToURL model.dieFace, size 100 100] 
        [text <| faceToURL model.dieFace]
    ],
    div [] [
      button [onClick Roll] [text "Roll!"]
    ]
  ]

faceToURL : Int -> String
faceToURL face =
  case face of
    1 -> "http://images.clipartpanda.com/number-one-clipart-847-blue-number-one-clip-art.png"
    2 -> "http://skiblandford.org/wp-content/uploads/2015/04/two.png"
    3 -> "http://vignette1.wikia.nocookie.net/phobia/images/f/f4/Three.png/revision/latest?cb=20161112225540"
    4 -> "http://www.maximumfun.org/images/four.jpg"
    5 -> "https://upload.wikimedia.org/wikipedia/commons/8/8e/Kismet-Five.png"
    6 -> "http://www.clipartkid.com/images/305/cartoon-number-six-clip-art-image-blue-with-eyes-O1C6PO-clipart.png"
    otherwise -> "https://openclipart.org/image/2400px/svg_to_png/231632/Psychedelic-3D-Question-Mark.png"

-- imgGen: Random.Generator String
-- imgGen = Random.map faceToURL (Random.int 1 6)
    
update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    Roll -> (model, Random.generate NewFace (Random.int 1 6))
    NewFace face -> ({ model | dieFace = face }, Cmd.none)

init : (Model, Cmd Msg)
init = ({ dieFace = 0 }, Cmd.none)

