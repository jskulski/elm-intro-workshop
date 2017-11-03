import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type Status
  = ALL_MATCH
  | PASSWORD_DONT_MATCH
  | EMAIL_DONT_MATCH

type alias Model =
  { email : String
  , emailAgain : String
  , password : String
  , passwordAgain : String
  , status: Status
  }


model : Model
model =
  Model "" "" "" "" ALL_MATCH


-- UPDATE

type Msg
    = Email String
    | EmailAgain String
    | Password String
    | PasswordAgain String

update : Msg -> Model -> Model
update msg model =
  model
  |> updateProperties msg
  |> updateStatus

updateProperties : Msg -> Model -> Model
updateProperties msg model =
  case msg of
    Email email ->
      { model | email = email }

    EmailAgain emailAgain ->
      { model | emailAgain = emailAgain }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

updateStatus : Model -> Model
updateStatus model =
    if model.password /= model.passwordAgain then
      {model | status = PASSWORD_DONT_MATCH }
    else if model.email /= model.emailAgain then
      {model | status = EMAIL_DONT_MATCH }
    else
      {model | status = ALL_MATCH }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ type_ "text", placeholder "Email", onInput Email ] []
    , input [ type_ "text", placeholder "Re-enter Email", onInput EmailAgain ] []
    , input [ type_ "password", placeholder "Password", onInput Password ] []
    , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , viewValidation model
    ]



colorFromStatus : Status -> String
colorFromStatus status =
  case status of
    EMAIL_DONT_MATCH ->
      "red"
    PASSWORD_DONT_MATCH ->
      "red"
    ALL_MATCH ->
      "green"


messageFromStatus : Status -> String
messageFromStatus status =
  case status of
    EMAIL_DONT_MATCH ->
      "Emails do no match!"
    PASSWORD_DONT_MATCH ->
      "Passwords do no match!"
    ALL_MATCH ->
      "Ok!"

viewValidation : Model -> Html msg
viewValidation model =
  let
    color = colorFromStatus model.status
    message = messageFromStatus model.status
  in
    div [ style [("color", color)] ] [ text message ]