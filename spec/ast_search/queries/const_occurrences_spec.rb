RSpec.describe AstSearch::Queries::ConstOccurrences do
  describe ".call" do
    subject(:result) { described_class.new.call(ast) }

    let(:ast) { AstSearch.parse(src) }

    context "with regular constants" do
      let(:src) do
        <<-SRC
          FOO
          BAR
          Foo
          Bar
        SRC
      end

      it { is_expected.to eq %w(FOO BAR Foo Bar) }
    end

    context "with constant assignments" do
      let(:src) do
        <<-SRC
          FOO = 1
          BAR
        SRC
      end

      it { is_expected.to eq %w(BAR) }
    end

    context "with class definitions" do
      let(:src) do
        <<-SRC
          class Foo
          end
          Bar
        SRC
      end

      it { is_expected.to eq %w(Foo Bar) }
    end

    context "with namespaced constants" do
      let(:src) do
        <<-SRC
          Foo::BAR
        SRC
      end

      it { is_expected.to eq %w(Foo::BAR) }
    end
  end
end
