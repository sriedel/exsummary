defmodule ExSummary.Stopwords do
  @stopwords "config/stopwords.txt" |> File.read! |> String.split
  @stopword_set  @stopwords |> MapSet.new
  @stopword_re with {:ok, re } <- Regex.compile( "(\\b\\s*)(?:#{Enum.join( @stopwords, "|" )})(\\s*\\b)" ), do: re
  
  @spec list() :: [ binary ]
  def list, do: @stopwords

  @spec filter( binary ) :: binary
  def filter( text ) when is_binary( text ) do 
    @stopword_re
    |> Regex.replace( text, "\\1\\2" ) 
    |> String.replace( ~r/\s+/, " " ) 
    |> String.trim
  end

  @spec filter( [ binary ] ) :: [ binary ]
  def filter( word_list ) when is_list( word_list ) do
    word_list
    |> Enum.filter( &( !is_stopword?( &1 ) ) )
  end

  defp is_stopword?( word ) do
    MapSet.member?( @stopword_set, word )
  end
end
