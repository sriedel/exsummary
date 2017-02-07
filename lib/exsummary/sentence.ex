defmodule ExSummary.Sentence do
  @known_abbreviations [ "US" ]
  @known_abbreviation_re_string "\\s*\\b(" <> Enum.join( @known_abbreviations, "|" ) <> ")\\b\\s*"

  @spec split_into_sentences( binary ) :: [ binary ]
  def split_into_sentences( text ) do
    matching_indices = Regex.scan( ~r/(\S+)[.?!]\s+\p{Lu}/u, text, return: :index )
    Enum.reduce( matching_indices, [], fn( match, acc ) ->
      [ { match_index, _ }, { previous_token_index, previous_token_length } ] = match
      previous_token = binary_part( text, previous_token_index, previous_token_length )
      stripped_token = String.replace( previous_token, ~r/\W/, "" )

      if Enum.member?( @known_abbreviations, stripped_token ) do
        acc
      else
        [ previous_token_index + previous_token_length + 1 | acc ]
      end

    end )
    |> split_text_on_bytes( text, [] )
    |> Enum.map( &( String.trim( &1 ) ) )
  end

  defp split_text_on_bytes( [], text, acc ), do: [ text | acc ]
  defp split_text_on_bytes( [ index ], text, acc ) do
    [ binary_part( text, 0, index ) | [ binary_part( text, index + 1, byte_size( text ) - index - 1 ) | acc ] ]
  end
  defp split_text_on_bytes( [ index2, index1, rest ], text, acc ) do
    split_text_on_bytes( [ index1 | rest ], text, [ binary_part( text, index1 + 1, index2 - index1 ) | acc ] ) 
    
  end

end
