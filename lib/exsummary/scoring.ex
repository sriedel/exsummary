defmodule ExSummary.Scoring do
  @spec word_score_map( map ) :: map
  def word_score_map( histogram ) when is_map( histogram ) do
    #NOTE: histogram_total is being computed for each histogram entry. This can
    #      be improved upon. (sr 2017-02-06)
    for { word, frequency } <- histogram,
        into: %{}, 
        do: { word, word_score( histogram, word ) }
  end

  @spec word_score( map, binary ) :: float
  def word_score( histogram, word ) do
    if Map.has_key?( histogram, word ) do
      histogram[word] / histogram_total( histogram )
    else
      0.0
    end
  end

  defp histogram_total( histogram ) do
    Enum.reduce( histogram, 0, fn( {_,v}, acc ) -> v + acc end )
  end
end
