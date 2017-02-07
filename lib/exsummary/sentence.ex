defmodule ExSummary.Sentence do
  @known_abbreviations [ "us" ]

  @spec split_into_sentences( binary ) :: [ binary ]
  def split_into_sentences( text ) do
    ~r/(\S+)[.?!]\s+\p{Lu}/u
    |> Regex.scan( text, return: :index )
    |> Enum.reduce( [], fn( match, acc ) ->
      [ _, { previous_token_index, previous_token_length } ] = match
      previous_token = binary_part( text, previous_token_index, previous_token_length )

      if known_abbreviation?( previous_token ) do
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
    first_substring = binary_part( text, 0, index )
    second_substring_length = byte_size( text ) - index - 1
    second_substring = binary_part( text, index + 1, second_substring_length )

    [ first_substring, second_substring | acc ]
  end
  defp split_text_on_bytes( [ index2, index1, rest ], text, acc ) do
    substring_length = index2 - index1
    split_text_on_bytes( [ index1 | rest ], 
                         text, 
                         [ binary_part( text, index1 + 1, substring_length ) | acc ] ) 
  end

  defp known_abbreviation?( word ) do
    normalized_word = word
                      |> String.replace( ~r/\W/, "" ) 
                      |> String.downcase
    Enum.member?( @known_abbreviations, normalized_word )
  end

end
