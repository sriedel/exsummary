defmodule ExSummary.Segmentation do
  @known_abbreviations MapSet.new( [ "us" ] )

  @doc """
    Segments the given text into a list of sentences.
  """
  @spec sentence_segmentation( binary ) :: [ binary ]
  def sentence_segmentation( text ) do
    ~r/(\S+)[.?!]\s+\p{Lu}/u
    |> Regex.scan( text, return: :index )
    |> Enum.reduce( [], fn( [ _, { prev_token_index, prev_token_length } ], acc ) ->
      prev_token = binary_part( text, prev_token_index, prev_token_length )

      [ { prev_token_index + prev_token_length + 1, prev_token } | acc ]
    end )
    |> Enum.filter( fn( { _index, token } ) -> !known_abbreviation?( token ) end )
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

  defp known_abbreviation?( word ) do
    normalized_word = word
                      |> String.replace( ~r/\W/, "" ) 
                      |> String.downcase
    MapSet.member?( @known_abbreviations, normalized_word )
  end

  @doc """
    Segments the given text into a list of words.
  """
  @spec word_segmentation( binary ) :: [ binary ]
  def word_segmentation( text ) do
    text
    |> String.trim
    |> String.split( ~r/\s+\b|\b\s+/ )
  end

  @doc """
    Normalizes the given word into a form that can be processed by the stopword
    and scoring logic.

    Apostrophe equivalents are transformed into the character "'", and any other
    non-alphanumeric character is removed.
  """
  @spec normalize_word( binary ) :: binary
  def normalize_word( word ) do
    word 
    |> String.replace( ~r/[\x{0060}\x{00b4}\x{2018}\x{2019}]/u, "'" )
    |> String.replace( ~r/[^\w']/u, "" )
    |> String.downcase
  end
end
