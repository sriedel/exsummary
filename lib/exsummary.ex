defmodule ExSummary do
  @moduledoc """
  """

  @spec summarize( binary, pos_integer ) :: binary
  def summarize( text, number_of_sentences ) when is_integer( number_of_sentences ) 
                                              and number_of_sentences > 0 do
    full_sentences = ExSummary.Sentence.split_into_sentences( text )

    stemmed_sentences = full_sentences
                        |> Enum.map( &ExSummary.Stopwords.filter/1 )
                        |> Enum.map( &stem_text/1 )


    stemmed_text = stemmed_sentences
                   |> Enum.join( " " )
 
    word_scores = stemmed_text 
                  |> ExSummary.WordFrequency.histogram
                  |> ExSummary.Scoring.word_score_map

    sentence_scores = stemmed_sentences
                      |> Enum.map( &String.split/1 )
                      |> Enum.map( &( ExSummary.Scoring.word_list_score( word_scores, &1 ) ) )

    sentence_scores_with_position = Enum.zip( [ 1..length( sentence_scores ), sentence_scores, full_sentences ] )
    sentence_scores_with_position 
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
end
