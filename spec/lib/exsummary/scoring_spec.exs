defmodule ExSummary.ScoringSpec do
  use ESpec

  let :histogram, do: %{ "a" => 1,
                         "b" => 2,
                         "c" => 3 }

  describe ".word_score_map" do
    let :expected_score_map, do: %{ "a" => 1/6,
                                    "b" => 2/6,
                                    "c" => 3/6 }
    it "should return a mapping of words to the word's score" do
      expect ExSummary.Scoring.word_score_map( histogram() ) |> to( eq expected_score_map() )
      
    end
  end

  describe ".word_score" do
    context "when the queried word is part of the histogram" do
      it "should return the expected score for a word given a histogram" do
        expect ExSummary.Scoring.word_score( histogram(), "a" ) |> to( eq (1.0/6.0) )
        expect ExSummary.Scoring.word_score( histogram(), "b" ) |> to( eq (2.0/6.0) )
        expect ExSummary.Scoring.word_score( histogram(), "c" ) |> to( eq (3.0/6.0) )
      end
    end

    context "when the queried word is not part of the histogram" do
      it "should return 0" do
        expect ExSummary.Scoring.word_score( histogram(), "i don't exist" ) |> to( eq 0 )
      end
    end
  end

end
