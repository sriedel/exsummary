defmodule ExSummary.Scoring do
  @spec word_score_map( map ) :: map
  def word_score_map( histogram ) when is_map( histogram ) do
    total = histogram_total( histogram )
    for { word, frequency } <- histogram,
        into: %{}, 
        do: { word, frequency / total }
  end

  @spec word_score( map, binary ) :: float
  def word_score( histogram, word ) do
    total = histogram_total( histogram )
    Map.get( histogram, word, 0 ) / total
  end

  defp histogram_total( histogram ) do
    Enum.reduce( histogram, 0, fn( {_,v}, acc ) -> v + acc end )
  end
end
