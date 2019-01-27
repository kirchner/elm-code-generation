module Pattern exposing (Point)

{-|

@docs Point

@generate-docs-json-encode
@generate-docs-json-decoder

-}


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
        { basePoint : Point
        , angle : Float
        , distance : Float
        }
