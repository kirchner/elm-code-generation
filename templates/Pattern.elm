module Pattern exposing (Point)

{-|

@docs Point

@generate-docs-json-encode
@generate-docs-json-decoder

-}

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.CodeGeneration as Decode
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode exposing (Value)
import Json.Encode.CodeGeneration as Encode


type A object
    = That Int
    | This object


{-| This type represents a point.

@generate-type-internal PointInfo
@generate-type-tag PointTag
@generate-function-tags pointTags
@generate-function-tag-from-type tagFromPoint
@generate-json-encode encodePoint
@generate-json-decoder pointDecoder

-}
type Point
    = Origin
        { x : Float
        , y : Float
        }
    | FromOnePoint
        { basePoint : A Point
        , angle : Float
        , distance : Float
        }


encodeA : (object -> Value) -> A object -> Value
encodeA encodeObject aObject =
    case aObject of
        That id ->
            Encode.withType "that"
                [ ( "name", Encode.int id ) ]

        This object ->
            Encode.withType "this"
                [ ( "object", encodeObject object ) ]


aDecoder : Decoder object -> Decoder (A object)
aDecoder objectDecoder =
    Decode.oneOf
        [ Decode.succeed That
            |> Decode.required "id" Decode.int
            |> Decode.ensureType "that"
        , Decode.succeed This
            |> Decode.required "object" objectDecoder
            |> Decode.ensureType "this"
        ]
