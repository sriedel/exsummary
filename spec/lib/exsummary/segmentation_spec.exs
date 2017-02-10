defmodule ExSummary.SegmentationSpec do
  use ESpec

  describe ".word_segmentation" do
    context "it should split words on word boundaries and remove leading and training space" do
      expect ExSummary.Segmentation.word_segmentation( "   foo Bar (baz)  quux  " ) |> to( eq [ "foo", "Bar", "(baz)", "quux" ] )
    end
  end

  describe ".normalize_word" do
    context "a word that doesn't need processing" do
      it "will be returned as given" do
        expect ExSummary.Segmentation.normalize_word( "foo" ) |> to( eq "foo" )
      end
    end

    context "capitalization" do
      it "will transform all characters to lower case" do
        expect ExSummary.Segmentation.normalize_word( "FooBar" ) |> to( eq "foobar" )
      end
    end

    context "a word with a UTF8 apostrophe" do
      it "will have the apostrophe replaced by a ' character" do
        expect ExSummary.Segmentation.normalize_word( "can`t" ) |> to( eq "can't" )
        expect ExSummary.Segmentation.normalize_word( "can´t" ) |> to( eq "can't" )
        expect ExSummary.Segmentation.normalize_word( "can‘t" ) |> to( eq "can't" )
        expect ExSummary.Segmentation.normalize_word( "can’t" ) |> to( eq "can't" )
      end
    end

    context "a word with non-alphanumeric characters" do
      it "will have the non-alphanumeric characters removed" do
        expect ExSummary.Segmentation.normalize_word( "Foo.Bar!22~!" ) |> to( eq "foobar22" )
      end
    end
  end
end
