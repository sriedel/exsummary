defmodule ExSummary.AbbreviationsSpec do
  use ESpec

  describe ".list" do
    it "should return a MapSet of the defined abbreviations" do
      expect ExSummary.Abbreviations.list |> to( be_map() )
    end
  end

  describe ".is_known_abbreviation?" do
    context "for a word that is not a known abbreviation" do
      it "should return false" do
        expect ExSummary.Abbreviations.is_known_abbreviation?( "i'm not an abbreviation" ) |> to( eq false )
      end
    end

    context "for a word that is a known abbreviation" do
      it "should return true if the abbreviation is delimited by periods and the characters are capitalized" do
        expect ExSummary.Abbreviations.is_known_abbreviation?( "U.S." ) |> to( eq true)
      end

      it "should return true if the abbreviation is delimited by periods and the characters are not capitalized" do
        expect ExSummary.Abbreviations.is_known_abbreviation?( "u.s." ) |> to( eq true)
      end

      it "should return true if the abbreviation is not delimited by periods and the characters are mixed case" do
        expect ExSummary.Abbreviations.is_known_abbreviation?( "KPdSU" ) |> to( eq true)
      end
    end
  end
end
