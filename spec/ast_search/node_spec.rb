RSpec.describe AstSearch::Node do
  subject(:node) { described_class.new(ast) }

  let(:ast) { AstSearch.parse(src) }

  describe "#const?" do
    subject { node.const? }

    context "with a constant" do
      let(:src) { "FOO" }

      it { is_expected.to be }
    end

    context "with a non-constant" do
      let(:src) { "foo" }

      it { is_expected.to_not be }
    end
  end

  describe "#class?" do
    subject { node.class? }

    context "with a class" do
      let(:src) { "class Foo end" }

      it { is_expected.to be }
    end

    context "with a non-class" do
      let(:src) { "FOO" }

      it { is_expected.to_not be }
    end
  end

  describe "#module?" do
    subject { node.module? }

    context "with a module" do
      let(:src) { "module Foo end" }

      it { is_expected.to be }
    end

    context "with a non-module" do
      let(:src) { "FOO" }

      it { is_expected.to_not be }
    end
  end

  describe "#name" do
    subject { node.name }

    context "with a constant" do
      let(:src) { "FOO" }

      it { is_expected.to eq "FOO" }
    end

    context "with a class" do
      let(:src) { "class Foo end" }

      it { is_expected.to eq "Foo" }
    end

    context "with a module" do
      let(:src) { "module Foo end" }

      it { is_expected.to eq "Foo" }
    end

    context "when name is not available" do
      let(:src) { "123 + 3" }

      it { is_expected.to be_nil }
    end
  end

  describe "#source" do
    subject { node.source }

    context "with a class" do
      let(:src) { "class Foo end" }

      it { is_expected.to eq "class Foo end" }
    end
  end

  describe "#children" do
    subject { node.children }

    context "when children are not available" do
      let(:src) { "nil" }

      it { is_expected.to eq [] }
    end

    context "when children are available" do
      let(:src) { "class Foo end" }

      it { is_expected.to be }
    end
  end
end
