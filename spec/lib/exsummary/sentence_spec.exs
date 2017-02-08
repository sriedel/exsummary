defmodule ExSummary.SentenceSpec do
  use ESpec

  describe ".split_into_sentences" do
    context "if the text has no punctuation" do
      let :text, do: "this is a text without punctuation"

      it "should return a list of one element containing the input text" do
        expect ExSummary.Sentence.split_into_sentences( text() ) |> to( eq [ text() ] )
      end
    end

    context "if the text only has a period at its end" do
      let :text, do: "this is a text with a period at the end."

      it "should return a list of one element containing the input text" do
        expect ExSummary.Sentence.split_into_sentences( text() ) |> to( eq [ text() ] )
      end
    end

    context "if the text only has an exclamation mark at its end" do
      let :text, do: "this is a text with an exclamation mark at the end!"

      it "should return a list of one element containing the input text" do
        expect ExSummary.Sentence.split_into_sentences( text() ) |> to( eq [ text() ] )
      end
    end

    context "if the text only has a question mark at its end" do
      let :text, do: "is this a text with a question mark at the end?"

      it "should return a list of one element containing the input text" do
        expect ExSummary.Sentence.split_into_sentences( text() ) |> to( eq [ text() ] )
      end
    end

    context "if the text has multiple punctuation marks interspersed" do
      context "and before an end-of-sentence-mark is a known abbreviation" do
        let :text, do: "The Trump administration argued the president has broad authority to decide who can and can’t enter the U.S. and that preventing him from doing so puts national security at risk, as it sought to persuade an appeals court to reinstate a travel ban."

        it "should not be counted as an end-of-sentence" do
          expect ExSummary.Sentence.split_into_sentences( text() ) |> to( eq [ text() ] )
        end
      end

      context "and before an end-of-sentence-mark is no known abbreviation" do
        context "and the following token is capitalized" do
          let :sentence1, do: "The Trump administration argued the president has broad authority to decide who can and can’t enter the here."
          let :sentence2, do: "This puts national security at risk, as it sought to persuade an appeals court to reinstate a travel ban."
          let :text, do: Enum.join( [ sentence1(), sentence2() ], " " )

          it "should be counted as an end-of-sentence" do
            expect ExSummary.Sentence.split_into_sentences( text() ) |> to( eq [ sentence1(), sentence2() ] )
          end
        end

        context "and the following token is not capitalized" do
          let :text, do: "The Trump administration argued the president has broad authority to decide who can and can’t enter the ... and that preventing him from doing so puts national security at risk, as it sought to persuade an appeals court to reinstate a travel ban."

          it "should not be counted as an end-of-sentence" do
            expect ExSummary.Sentence.split_into_sentences( text() ) |> to( eq [ text() ] )
          end
        end
      end
    end

    it "can separate one sentence appropriately" do
      sentence = "I am foo."
      expect ExSummary.Sentence.split_into_sentences( sentence ) |> to( eq [ sentence ] )
    end

    it "can separate two sentences appropriately" do
      sentences = [ "I am foo.", "I am bar." ]
      text = Enum.join( sentences, " " )
      expect ExSummary.Sentence.split_into_sentences( text ) |> to( eq sentences )
    end

    it "can separate three sentences appropriately" do
      sentences = [ "I am foo.", "I am bar.", "I am baz." ]
      text = Enum.join( sentences, " " )
      expect ExSummary.Sentence.split_into_sentences( text ) |> to( eq sentences )
    end

    it "can separate four (and more) sentences appropriately" do
      sentences = [ "I am foo.", "I am bar.", "I am baz.", "I am quux." ]
      text = Enum.join( sentences, " " )
      expect ExSummary.Sentence.split_into_sentences( text ) |> to( eq sentences )
    end
  end
end
