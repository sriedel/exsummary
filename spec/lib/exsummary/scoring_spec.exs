defmodule ExSummary.ScoringSpec do
  use ESpec

  let :histogram, do: %{ "a" => 1,
                         "b" => 2,
                         "c" => 3 }
  let :score_map, do: %{ "a" => 1/6,
                         "b" => 2/6,
                         "c" => 3/6 }

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

  describe ".word_list_score" do
    context "when the list is empty" do
      it "should return 0" do
        expect ExSummary.Scoring.word_list_score( score_map(), [] ) |> to( eq 0 )
      end
    end

    context "when the list has one element" do
      context "and the element has an entry in the word score map" do
        it "should return that elements score" do
          expect ExSummary.Scoring.word_list_score( score_map(), [ "a" ] ) |> to( eq 1/6 )
        end
      end

      context "and the element does not have an entry in the word score map" do
        it "should return 0 " do
          expect ExSummary.Scoring.word_list_score( score_map(), [ "foo" ] ) |> to( eq 0 )
        end
      end
    end

    context "and the list has multiple elements" do
      it "should return the sum of the individual words scores" do
        expect ExSummary.Scoring.word_list_score( score_map(), [ "a", "b", "foo", "c" ] ) |> to( eq 1 )
      end
    end
  end

end
