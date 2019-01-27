module Json.Decode.CodeGeneration exposing (ensureType)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode


ensureType : String -> Decoder a -> Decoder a
ensureType type_ dataDecoder =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\rawType ->
                if rawType == type_ then
                    dataDecoder

                else
                    Decode.fail "not a valid type"
            )
