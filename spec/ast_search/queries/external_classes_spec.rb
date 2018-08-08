RSpec.describe AstSearch::Queries::ExternalClasses do
  describe ".call" do
    subject(:result) { described_class.new.call(ast) }

    let(:ast) { AstSearch.parse(src) }

    class Bar
    end

    context "when the referenced class is defined outside of the parsed code" do
      let(:src) do
        <<~SRC
          class Foo
            Bar
          end
        SRC
      end

      it { is_expected.to eq [Bar] }
    end

    context "when the referenced class is NOT defined outside of the parsed code" do
      let(:src) do
        <<~SRC
          class Foo
            Bar1
          end
        SRC
      end

      it { is_expected.to eq [] }
    end

    context "when the referenced class is defined inside of the parsed code" do
      let(:src) do
        <<~SRC
          class Foo
            class Bar
            end

            Bar
          end
        SRC
      end

      it { is_expected.to eq [] }
    end
  end
end
