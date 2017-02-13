defmodule ExSummary.WordFrequency do
  @spec histogram( binary ) :: map
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
end
