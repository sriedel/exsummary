defmodule ExSummary.WordFrequency do
  @spec histogram( binary ) :: map
  def histogram( text ) do
    text
    |> String.split
    |> Enum.group_by( &( String.replace( &1, ~r/[^'\p{Xan}]/, "" ) ) )
    |> Enum.map( fn( {key, value} ) -> { key, Enum.count( value ) } end )
    |> Enum.into( %{} )
  end
end
