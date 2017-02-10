defmodule ExSummary.Abbreviations do
  @abbreviations "config/abbreviations.txt" |> File.read! |> String.split |> MapSet.new

  @spec list() :: %MapSet{}
  def list, do: @abbreviations

  @spec is_known_abbreviation?( binary ) :: boolean
  def is_known_abbreviation?( word ) do
    normalized_word = word
                      |> String.replace( ~r/\W/, "" ) 
                      |> String.downcase
    MapSet.member?( @abbreviations, normalized_word )
  end
end
