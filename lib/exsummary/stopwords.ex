defmodule ExSummary.Stopwords do
  @stopwords "config/stopwords.txt" |> File.read! |> String.split
  
  @spec list() :: [ binary ]
  def list, do: @stopwords
end
