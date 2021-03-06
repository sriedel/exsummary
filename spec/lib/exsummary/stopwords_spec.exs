defmodule ExSummary.StopwordsSpec do
  use ESpec

  describe ".list" do
    it "should return a list of the defined stopwords" do
      expect ExSummary.Stopwords.list |> to( be_list() )
    end
  end

  describe ".filter" do
    it "should remove all occurrances of the stopwords from the given word list" do
      raw_text = ~w[ i am on it is nice i am off ]
      expected_result = ~w[ nice ]
      expect ExSummary.Stopwords.filter( raw_text ) |> to( eq expected_result )
    end
  end
end
