defmodule ExSummary.Sentence do
  @spec split_into_sentences( binary ) :: [ binary ]
  def split_into_sentences( text ) do
    ~r/(\S+)[.?!]\s+\p{Lu}/u
    |> Regex.scan( text, return: :index )
    |> Enum.reduce( [], fn( [ _, { prev_token_index, prev_token_length } ], acc ) ->
      prev_token = binary_part( text, prev_token_index, prev_token_length )

      [ { prev_token_index + prev_token_length + 1, prev_token } | acc ]
    end )
    |> Enum.filter( fn( { _index, token } ) -> !ExSummary.Abbreviations.is_known_abbreviation?( token ) end )
    |> Enum.map( fn( { index, _token } ) -> index end ) 
    |> split_text_on_bytes( text, [] )
    |> Enum.map( &String.trim/1 )
  end

  defp split_text_on_bytes( [], text, acc ), do: [ text | acc ]
  defp split_text_on_bytes( [ index | rest ], text, acc ) do
    substring_length = byte_size( text ) - index
    split_text_on_bytes( rest, 
                         binary_part( text, 0, index ),
                         [ binary_part( text, index, substring_length ) | acc ] ) 
  end
end
