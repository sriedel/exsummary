defmodule ExSummary.WordFrequencySpec do
  use ESpec

  describe ".histogram" do
    it "should return a map mapping words to their frequency in the passed text" do
      raw_text = "i am on. it is nice. i am off."
      expected_result = %{ "i"    => 2,
                           "am"   => 2,
                           "on"   => 1,
                           "it"   => 1,
                           "is"   => 1,
                           "nice" => 1,
                           "off"  => 1 }

      expect ExSummary.WordFrequency.histogram( raw_text ) |> to( eq expected_result )
    end
  end
end
