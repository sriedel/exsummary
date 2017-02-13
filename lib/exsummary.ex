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

  defp stem_word_list( word_list ) do
    word_list
    |> ExSummary.Stopwords.filter
    |> Enum.map( &Porter2.stem/1 )
  end

  defp stem_sentences( text ) do
    text
    |> ExSummary.Segmentation.segment
    |> Enum.map( &stem_word_list/1 )
  end

  defp build_word_score_map( stemmed_sentences ) do
    word_scores = stemmed_sentences
                  |> Enum.flat_map( &(&1) )
                  |> ExSummary.WordFrequency.histogram
                  |> ExSummary.Scoring.word_score_map
  end

  defp score_stemmed_sentences( stemmed_sentences, word_scores ) do
    stemmed_sentences
    |> Enum.map( &( ExSummary.Scoring.word_list_score( word_scores, &1 ) ) )
  end

  defp score_sentences_in_text( text ) do
    full_sentences = ExSummary.Segmentation.sentence_segmentation( text )
    stemmed_sentences = stem_sentences( text )

    word_scores = build_word_score_map( stemmed_sentences )

    sentence_scores = score_stemmed_sentences( stemmed_sentences, word_scores )

    Enum.zip( [ 1..length( sentence_scores ), sentence_scores, full_sentences ] )
  end
end
