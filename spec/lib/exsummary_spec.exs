defmodule ExSummarySpec do
  use ESpec

  describe ".summarize" do
    context "the number of sentences returned" do
      it "should return a single sentence if 1 is given" do
        expect ExSummary.summarize( "foo", 1 ) |> to( eq "foo" )
      end

      it "should return the number of sentences given" do
        summary = ExSummary.summarize( "Foo. Bar. Baz.", 2 )
        expect ExSummary.Sentence.split_into_sentences( summary ) |> length |> to( eq 2 )
      end

      it "should return the entire text if the number of sentences is larger than the sentences present" do
        text = "Foo. Bar. Baz." 
        expect ExSummary.summarize( text, 10 ) |> to( eq text )
      end
    end

    context "the string returned" do
      it "should return the sentences in the order given in the original text" do
        text = "Foo. Bar. Baz."
        text_sentences = ExSummary.Sentence.split_into_sentences( text )
        summary = ExSummary.summarize( text, 2 )
        summary_sentences = ExSummary.Sentence.split_into_sentences( summary )

        returned_text_sentences = text_sentences
                                  |> Enum.filter( &( Enum.member?( summary_sentences, &1 ) ) )
        expect summary_sentences |> to( eq returned_text_sentences )
      end

      it "should return the most significant sentences of the text" do
        text = "This is the extended form of a comment that got some interest on Hackernews. After a grace period of one year, Parse is now offline. This is a collection of learnings and technical decisions that might be useful for other companies running cloud services. At least, it directly affects the design of our own Backend-as-a-Service Baqend."

        expect ExSummary.summarize( text, 1 ) |> to( eq "This is a collection of learnings and technical decisions that might be useful for other companies running cloud services." )
        expect ExSummary.summarize( text, 2 ) |> to( eq "After a grace period of one year, Parse is now offline. This is a collection of learnings and technical decisions that might be useful for other companies running cloud services." )
        expect ExSummary.summarize( text, 3 ) |> to( eq "This is the extended form of a comment that got some interest on Hackernews. After a grace period of one year, Parse is now offline. This is a collection of learnings and technical decisions that might be useful for other companies running cloud services." )
        expect ExSummary.summarize( text, 4 ) |> to( eq text )

      end
    end

  end
end
