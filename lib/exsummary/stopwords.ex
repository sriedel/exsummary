defmodule ExSummary.Stopwords do
  @stopwords "config/stopwords.txt" |> File.read! |> String.split
  @stopword_re with {:ok, re } <- Regex.compile( "(\\b\\s*)(?:#{Enum.join( @stopwords, "|" )})(\\s*\\b)" ), do: re
  
  @spec list() :: [ binary ]
  def list, do: @stopwords

  @spec filter( binary ) :: binary
  def filter( text ) do 
    @stopword_re
    |> Regex.replace( text, "\\1\\2" ) 
    |> String.replace( ~r/\s+/, " " ) 
    |> String.trim
 end
end
