module Pattern exposing
    ( Pattern, empty
    , insertPoint
    , origin, fromOnePoint
    , A
    , Point, PointInfo(..)
    )

{-|


# Pattern

@docs Pattern, empty
@docs insertPoint


# Construct

@docs origin, fromOnePoint


# Objects

@docs A

@docs Point, PointInfo

-}

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.CodeGeneration as Decode
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode exposing (Value)
import Json.Encode.CodeGeneration as Encode



---- PATTERN


type Pattern
    = Pattern
        { points : Dict Int Point
        , nextPointId : Int
        }


empty : Pattern
empty =
    Pattern
        { points = Dict.empty
        , nextPointId = 0
        }


insertPoint : Point -> Pattern -> ( A Point, Pattern )
insertPoint point (Pattern data) =
    ( That data.nextPointId
    , Pattern
        { data
            | points = Dict.insert data.nextPointId point data.points
            , nextPointId = 1 + data.nextPointId
        }
    )



---- CONSTRUCT


origin : Float -> Float -> Point
origin x y =
    Point <|
        Origin
            { x = x
            , y = y
            }


fromOnePoint : A Point -> Float -> Float -> Point
fromOnePoint aPoint angle distance =
    Point <|
        FromOnePoint
            { basePoint = aPoint
            , angle = angle
            , distance = distance
            }



---- OBJECTS


{-| This type represents either an `object` or a reference to an `object`.

@rule-json-encode encodeA
@rule-json-decoder aDecoder

-}
type A object
    = That Int
    | This object


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


{-| This type represents a point.

@rule-json-encode encodePoint
@rule-json-decoder pointDecoder

-}
type Point
    = Point PointInfo


encodePoint : Point -> Value
encodePoint (Point info) =
    encodePointInfo info


pointDecoder : Decoder Point
pointDecoder =
    pointInfoDecoder
        |> Decode.map Point


{-| This type gives you all the information about a point.

@generate-type-tag Tag
@generate-function-tags pointInfoTags
@generate-function-tag-from-type tagFromPointInfo
@generate-json-encode encodePointInfo
@generate-json-decoder pointInfoDecoder

-}
type PointInfo
    = Origin
        { x : Float
        , y : Float
        }
    | FromOnePoint
        { basePoint : A Point
        , angle : Float
        , distance : Float
        }



{- vvvvv GENERATED CODE STARTS HERE vvvvv -}


type PointInfoTag
    = OriginTag
    | FromOnePointTag


pointTags : List PointInfoTag
pointTags =
    [ OriginTag
    , FromOnePointTag
    ]


tagFromPointInfo : PointInfo -> PointInfoTag
tagFromPointInfo info =
    case info of
        Origin _ ->
            OriginTag

        FromOnePoint _ ->
            FromOnePointTag


encodePointInfo : PointInfo -> Value
encodePointInfo info =
    case info of
        Origin stuff ->
            Encode.withType "origin"
                [ ( "x", Encode.float stuff.x )
                , ( "y", Encode.float stuff.y )
                ]

        FromOnePoint stuff ->
            Encode.withType "fromOnePoint"
                [ ( "basePoint", encodeA encodePoint stuff.basePoint )
                , ( "angle", Encode.float stuff.angle )
                , ( "distance", Encode.float stuff.distance )
                ]


type alias OriginStuff =
    { x : Float
    , y : Float
    }


type alias FromOnePointStuff =
    { basePoint : A Point
    , angle : Float
    , distance : Float
    }


pointInfoDecoder : Decoder PointInfo
pointInfoDecoder =
    Decode.oneOf
        [ Decode.succeed OriginStuff
            |> Decode.required "x" Decode.float
            |> Decode.required "y" Decode.float
            |> Decode.map Origin
            |> Decode.ensureType "origin"
        , Decode.succeed FromOnePointStuff
            |> Decode.required "basePoint" (Decode.lazy (\_ -> aDecoder pointDecoder))
            |> Decode.required "angle" Decode.float
            |> Decode.required "distance" Decode.float
            |> Decode.map FromOnePoint
            |> Decode.ensureType "fromOnePoint"
        ]



{- ^^^^^ GENERATED CODE ENDS HERE ^^^^^ -}
