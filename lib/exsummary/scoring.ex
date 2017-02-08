defmodule ExSummary.Scoring do
  @spec word_score_map( map ) :: map
  def word_score_map( histogram ) when is_map( histogram ) do
    total = histogram_total( histogram )
    for { word, frequency } <- histogram,
        into: %{}, 
        do: { word, score( frequency, total ) }
  end

  @spec word_score( map, binary ) :: float
  def word_score( histogram, word ) do
    total = histogram_total( histogram )
    score( Map.get( histogram, word, 0 ), total )
  end

  @spec word_list_score( map, [binary] ) :: float
  def word_list_score( word_score_map, list_of_words ) do
    list_of_words
    |> Enum.reduce( 0, &( &2 + Map.get( word_score_map, &1, 0 ) ) )
  end

  defp histogram_total( histogram ) do
    Enum.reduce( histogram, 0, fn( {_,v}, acc ) -> v + acc end )
  end

  defp score( 0, _ ), do: 0
  defp score( frequency, number_of_words ) do
    -:math.log2( frequency / number_of_words )
  end
end
