defmodule ExSummary.WordFrequencySpec do
  use ESpec

  describe ".histogram" do
    it "should return a map mapping words to their frequency in the passed word list" do
      raw_text = ~w[ i am on it is nice i am off foo-bar ]
      expected_result = %{ "i"       => 2,
                           "am"      => 2,
                           "on"      => 1,
                           "it"      => 1,
                           "is"      => 1,
                           "nice"    => 1,
                           "off"     => 1,
                           "foo-bar" => 1 }

      expect ExSummary.WordFrequency.histogram( raw_text ) |> to( eq expected_result )
    end
  end
end
