RSpec.describe AstSearch::NamePath do
  describe ".from_string" do
    let(:name) { described_class.from_string("Foo::Bar::Baz") }

    it "splits the string into array" do
      expect(name.to_a).to eq %w(Foo Bar Baz)
    end
  end

  describe "#to_a" do
    let(:name) { described_class.new(%w(FOO)) }

    it "returns the path array" do
      expect(name.to_a).to eq %w(FOO)
    end
  end

  describe "#+" do
    subject(:result) { name + "BAR" }

    let(:name) { described_class.new(["FOO"]) }

    it "returns a new instance" do
      expect(result).to_not be name
    end

    it "appends the element to path" do
      expect(result.to_a).to eq %w(FOO BAR)
    end
  end

  describe "#eql?" do
    subject { name.eql?(other) }

    let(:name) { described_class.new(%w(FOO)) }

    context "with same path" do
      let(:other) { described_class.new(%w(FOO)) }

      it { is_expected.to be }
    end

    context "with a different path" do
      let(:other) { described_class.new(%w(BAR)) }

      it { is_expected.to_not be }
    end
  end

  describe "#hash" do
    let(:name) { described_class.new(%w(FOO)) }

    it "delegates hash to the path" do
      expect(name.hash).to eq %w(FOO).hash
    end
  end

  describe "#shift" do
    subject(:result) { name.shift }

    let(:name) { described_class.new(%w(FOO BAR)) }

    it "returns a new instance" do
      expect(result).to_not be name
    end

    it "removes the first element from path" do
      expect(result.to_a).to eq %w(BAR)
    end
  end

  describe "#blank?" do
    subject(:result) { name.blank? }

    let(:name) { described_class.new(path) }

    context "with a blank path" do
      let(:path) { [] }

      it { is_expected.to be }
    end

    context "with a non-blank path" do
      let(:path) { %w(FOO) }

      it { is_expected.to_not be }
    end
  end

  describe "#to_s" do
    subject(:result) { name.to_s }

    let(:name) { described_class.new(%w(FOO BAR BAZ)) }

    it { is_expected.to eq "FOO::BAR::BAZ" }
  end

  describe "#constantize" do
    subject(:result) { name.constantize }

    module Foo
      BAR = 1
    end

    context "with `constantize` available" do
      let(:name) { described_class.new(%w(Foo BAR)) }

      before do
        allow(name).to receive(:to_s).and_return(double(String, constantize: Foo::BAR))
      end

      it { is_expected.to be Foo::BAR }
    end

    context "without `constantize`" do
      let(:name) { described_class.new(%w(Foo BAR)) }

      it { is_expected.to be Foo::BAR }
    end

    context "with undefined constant name" do
      let(:name) { described_class.new(%w(Foo BAZ)) }

      it { is_expected.to be_nil }
    end
  end
end
