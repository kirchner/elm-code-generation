module Pattern exposing
    ( A
    , Point
    )

{-|

@docs A

@docs Point

-}


{-| This type represents either an `object` or a reference to an `object`.

@rule-json-encode encodeA
@rule-json-decoder aDecoder

-}
type A object
    = That Int
    | This object


{-| This type represents a point.

@generate-type-internal @expose-constructors PointInfo
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
