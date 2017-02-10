defmodule ExSummary.SegmentationSpec do
  use ESpec
  describe ".segment" do
    let :text, do: "The Trump administration argued the president has broad authority to decide who can and can’t enter the U.S. and that preventing him from doing so puts national security at risk, as it sought to persuade an appeals court to reinstate a travel ban. The Trump administration argued the president has broad authority to decide who can and can’t enter the here. This puts national security at risk, as it sought to persuade an appeals court to reinstate a travel ban."
    let :expected, do: [
      ~w[ the trump administration argued the president has broad authority to decide who can and can't enter the us and that preventing him from doing so puts national security at risk as it sought to persuade an appeals court to reinstate a travel ban ],
      ~w[ the trump administration argued the president has broad authority to decide who can and can't enter the here ],
      ~w[ this puts national security at risk as it sought to persuade an appeals court to reinstate a travel ban ]
    ]

    it "should return a list of sentences which in turn are lists of normalized words" do
      expect ExSummary.Segmentation.segment( text() ) |> to( eq expected() )
    end
  end

  describe ".sentence_segmentation" do
    context "if the text has no punctuation" do
      let :text, do: "this is a text without punctuation"

      it "should return a list of one element containing the input text" do
        expect ExSummary.Segmentation.sentence_segmentation( text() ) |> to( eq [ text() ] )
      end
    end

    context "if the text only has a period at its end" do
      let :text, do: "this is a text with a period at the end."

      it "should return a list of one element containing the input text" do
        expect ExSummary.Segmentation.sentence_segmentation( text() ) |> to( eq [ text() ] )
      end
    end

    context "if the text only has an exclamation mark at its end" do
      let :text, do: "this is a text with an exclamation mark at the end!"

      it "should return a list of one element containing the input text" do
        expect ExSummary.Segmentation.sentence_segmentation( text() ) |> to( eq [ text() ] )
      end
    end

    context "if the text only has a question mark at its end" do
      let :text, do: "is this a text with a question mark at the end?"

      it "should return a list of one element containing the input text" do
        expect ExSummary.Segmentation.sentence_segmentation( text() ) |> to( eq [ text() ] )
      end
    end

    context "if the text has multiple punctuation marks interspersed" do
      context "and before an end-of-sentence-mark is a known abbreviation" do
        let :text, do: "The Trump administration argued the president has broad authority to decide who can and can’t enter the U.S. and that preventing him from doing so puts national security at risk, as it sought to persuade an appeals court to reinstate a travel ban."

        it "should not be counted as an end-of-sentence" do
          expect ExSummary.Segmentation.sentence_segmentation( text() ) |> to( eq [ text() ] )
        end
      end

      context "and before an end-of-sentence-mark is no known abbreviation" do
        context "and the following token is capitalized" do
          let :sentence1, do: "The Trump administration argued the president has broad authority to decide who can and can’t enter the here."
          let :sentence2, do: "This puts national security at risk, as it sought to persuade an appeals court to reinstate a travel ban."
          let :text, do: Enum.join( [ sentence1(), sentence2() ], " " )

          it "should be counted as an end-of-sentence" do
            expect ExSummary.Segmentation.sentence_segmentation( text() ) |> to( eq [ sentence1(), sentence2() ] )
          end
        end

        context "and the following token is not capitalized" do
          let :text, do: "The Trump administration argued the president has broad authority to decide who can and can’t enter the ... and that preventing him from doing so puts national security at risk, as it sought to persuade an appeals court to reinstate a travel ban."

          it "should not be counted as an end-of-sentence" do
            expect ExSummary.Segmentation.sentence_segmentation( text() ) |> to( eq [ text() ] )
          end
        end
      end
    end

    it "can separate one sentence appropriately" do
      sentence = "I am foo."
      expect ExSummary.Segmentation.sentence_segmentation( sentence ) |> to( eq [ sentence ] )
    end

    it "can separate two sentences appropriately" do
      sentences = [ "I am foo.", "I am bar." ]
      text = Enum.join( sentences, " " )
      expect ExSummary.Segmentation.sentence_segmentation( text ) |> to( eq sentences )
    end

    it "can separate three sentences appropriately" do
      sentences = [ "I am foo.", "I am bar.", "I am baz." ]
      text = Enum.join( sentences, " " )
      expect ExSummary.Segmentation.sentence_segmentation( text ) |> to( eq sentences )
    end

    it "can separate four (and more) sentences appropriately" do
      sentences = [ "I am foo.", "I am bar.", "I am baz.", "I am quux." ]
      text = Enum.join( sentences, " " )
      expect ExSummary.Segmentation.sentence_segmentation( text ) |> to( eq sentences )
    end
  end

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
