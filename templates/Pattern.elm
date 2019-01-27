module Pattern exposing (Point)

{-|

@docs Point

@generate-encode-docs
@generate-decoder-docs

-}


{-| This type represents a point.

@generate-info-type PointInfo
@generate-tag-type PointTag
@generate-tags pointTags
@generate-tag-from-type tagFromPoint
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