defmodule ExSummary.Segmentation do
  @doc """
    Segments the given text into a list of words.
  """
  @spec word_segmentation( binary ) :: [ binary ]
  def word_segmentation( text ) do
    text
    |> String.trim
    |> String.split( ~r/\s+\b|\b\s+/ )
  end

  @doc """
    Normalizes the given word into a form that can be processed by the stopword
    and scoring logic.

    Apostrophe equivalents are transformed into the character "'", and any other
    non-alphanumeric character is removed.
  """
  @spec normalize_word( binary ) :: binary
  def normalize_word( word ) do
    word 
    |> String.replace( ~r/[\x{0060}\x{00b4}\x{2018}\x{2019}]/u, "'" )
    |> String.replace( ~r/[^\w']/u, "" )
    |> String.downcase
  end
end
