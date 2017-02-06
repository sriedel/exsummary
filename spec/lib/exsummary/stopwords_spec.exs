defmodule ExSummary.StopwordsSpec do
  use ESpec

  describe ".list" do
    it "should return a list of the defined stopwords" do
      expect ExSummary.Stopwords.list |> to( be_list )
    end
  end
end
