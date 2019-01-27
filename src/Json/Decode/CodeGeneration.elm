module Json.Decode.CodeGeneration exposing (withType)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode


withType : String -> Decoder a -> Decoder a
withType type_ dataDecoder =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\rawType ->
                if rawType == type_ then
                    dataDecoder

                else
                    Decode.fail "not a valid type"
            )
