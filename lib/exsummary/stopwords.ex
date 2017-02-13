defmodule ExSummary.Stopwords do
  @stopwords "config/stopwords.txt" |> File.read! |> String.split
  @stopword_set  @stopwords |> MapSet.new
  
  @spec list() :: [ binary ]
  def list, do: @stopwords

  @spec filter( [ binary ] ) :: [ binary ]
  def filter( word_list ) when is_list( word_list ) do
    word_list
    |> Enum.filter( &is_not_stopword?/1 )
  end

  defp is_not_stopword?( word ) do
    !MapSet.member?( @stopword_set, word )
  end
end
