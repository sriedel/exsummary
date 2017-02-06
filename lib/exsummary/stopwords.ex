defmodule ExSummary.Stopwords do
  @stopwords "config/stopwords.txt" |> File.read! |> String.split
  @stopword_re with {:ok, re } <- Regex.compile( "\\b\\s*(#{Enum.join( @stopwords, "|" )})\\s*\\b" ), do: re
  
  @spec list() :: [ binary ]
  def list, do: @stopwords

  @spec filter( binary ) :: binary
  def filter( text ), do: IO.inspect( @stopword_re ) && String.replace( text, @stopword_re, "" ) 
end
