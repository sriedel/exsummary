defmodule ExSummary.WordFrequency do
  @spec histogram( binary ) :: map
  def histogram( text ) when is_binary( text ) do
    text
    |> valid_word_list
    |> Enum.reduce( %{}, fn( word, histogram ) ->
      {_, histogram} = Map.get_and_update( histogram, word, &update_word_frequency/1 ) 
      histogram
    end )
  end

  def histogram( word_list ) when is_list( word_list ) do
    word_list
    |> Enum.reduce( %{}, fn( word, histogram ) ->
      {_, histogram} = Map.get_and_update( histogram, word, &update_word_frequency/1 ) 
      histogram
    end )
  end

  defp update_word_frequency( previous_value ) do
    { previous_value, ( previous_value || 0 ) + 1 }
  end

  defp is_valid_word?( word ) do
    String.length( word ) > 0 && !Regex.match?( ~r/[^\p{Xan}]/, word )
  end

  defp valid_word_list( text ) do
    text 
    |> String.split( ~r/\s*(\b|[^\p{Xan}])\s*/ )
    |> Enum.filter( &is_valid_word?/1 )
  end
end
