defmodule ExSummary do
  @moduledoc """
  """

  @spec summarize( binary, pos_integer ) :: binary
  def summarize( text, number_of_sentences ) when is_integer( number_of_sentences ) 
                                              and number_of_sentences > 0 do

    text
    |> score_sentences_in_text
    |> Enum.sort_by( fn( { _pos, score, _sentence } ) -> score end, &>=/2 )
    |> Enum.take( number_of_sentences )
    |> Enum.sort_by( fn( { pos, _score, _sentence } ) -> pos end )
    |> Enum.map( fn( { _pos, _score, sentence } ) -> sentence end )
    |> Enum.join( " " )
  end

  defp stem_text( text ) do
    text
    |> String.split
    |> Enum.map( &Porter2.stem/1 )
    |> Enum.join( " " )
  end

  defp score_sentences( word_scores, sentences ) do
    sentences
    |> Enum.map( &String.split/1 )
    |> Enum.map( &( ExSummary.Scoring.word_list_score( word_scores, &1 ) ) )
  end

  defp score_words( text ) do
    text 
    |> ExSummary.WordFrequency.histogram
    |> ExSummary.Scoring.word_score_map
  end

  defp stem_sentences( sentence_list ) do
    sentence_list
    |> Enum.map( &ExSummary.Stopwords.filter/1 )
    |> Enum.map( &stem_text/1 )
  end

  defp score_sentences_in_text( text ) do
    full_sentences = ExSummary.Sentence.split_into_sentences( text )
    stemmed_sentences = stem_sentences( full_sentences )

    sentence_scores = stemmed_sentences
                      |> Enum.join( " " )
                      |> score_words
                      |> score_sentences( stemmed_sentences )

    Enum.zip( [ 1..length( sentence_scores ), sentence_scores, full_sentences ] )
  end
end
