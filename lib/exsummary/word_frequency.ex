defmodule ExSummary.WordFrequency do
  @spec histogram( binary ) :: map
  def histogram( text ) do
    text
    |> valid_word_list
    |> Enum.reduce( %{}, fn( word, histogram ) ->
      {_, histogram} = Map.get_and_update( histogram, word, &( { &1, (&1||0) + 1 } ) ) 
      histogram
    end )
  end

  defp is_valid_word?( word ) do
    String.length( word ) > 0 && !Regex.match?( ~r/[^\p{Xan}]/, word )
  end

  defp valid_word_list( text ) do
    text 
    |> String.split( ~r/\s*(\b|[^\p{Xan}])\s*/ )
    |> Enum.filter( &( is_valid_word?( &1 ) ) )
  end
end
