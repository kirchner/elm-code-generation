module Output exposing
    ( Point, PointInfo(..), PointTag(..)
    , encodePoint
    , pointDecoder
    )

{-|

@docs Point, PointInfo, PointTag


# Encode

@docs encodePoint


# Decoder

@docs pointDecoder

-}

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.CodeGeneration as Decode
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode exposing (Value)
import Json.Encode.CodeGeneration as Encode


{-| This type represents a point.
-}
type Point
    = Point PointInfo


{-| -}
type PointInfo
    = Origin
        { x : Float
        , y : Float
        }
    | FromOnePoint
        { basePoint : Point
        , angle : Float
        , distance : Float
        }


{-| -}
type PointTag
    = OriginTag
    | FromOnePointTag



---- ENCODE


{-| -}
encodePoint : Point -> Value
encodePoint (Point info) =
    case info of
        Origin stuff ->
            Encode.withType "origin"
                [ ( "x", Encode.float stuff.x )
                , ( "y", Encode.float stuff.y )
                ]

        FromOnePoint stuff ->
            Encode.withType "fromOnePoint"
                [ ( "basePoint", encodePoint stuff.basePoint )
                , ( "angle", Encode.float stuff.angle )
                , ( "distance", Encode.float stuff.distance )
                ]



---- DECODER


type alias OriginStuff =
    { x : Float
    , y : Float
    }


type alias FromOnePointStuff =
    { basePoint : Point
    , angle : Float
    , distance : Float
    }


{-| -}
pointDecoder : Decoder Point
pointDecoder =
    Decode.oneOf
        [ Decode.succeed OriginStuff
            |> Decode.required "x" Decode.float
            |> Decode.required "y" Decode.float
            |> Decode.map Origin
            |> Decode.withType "origin"
        ]
        |> Decode.map Point
