RSpec.describe AstSearch::Queries::ClassDefs do
  describe ".call" do
    subject(:result) { described_class.new.call(ast) }

    let(:ast) { AstSearch.parse(src) }

    context "with a single class" do
      let(:src) do
        <<-SRC
          class Foo
          end
        SRC
      end

      it { is_expected.to eq %w(Foo) }
    end

    context "with a namespaced class" do
      let(:src) do
        <<-SRC
          module Foo
            class Bar
            end
          end
        SRC
      end

      it { is_expected.to eq %w(Foo::Bar) }
    end

    context "with a nested classes" do
      let(:src) do
        <<-SRC
          class Foo
            class Bar
            end
          end
        SRC
      end

      it { is_expected.to eq %w(Foo Foo::Bar) }
    end

    context "with a nested namespaced class" do
      let(:src) do
        <<-SRC
          class Foo
            module Bar
              class Baz
              end
            end
          end
        SRC
      end

      it { is_expected.to eq %w(Foo Foo::Bar::Baz) }
    end

    context "with a module not containing any classes" do
      let(:src) do
        <<-SRC
          module Foo
           module Bar
           end
          end
        SRC
      end

      it { is_expected.to eq [] }
    end

    context "without block definitions" do
      let(:src) do
        <<-SRC
          Foo
          BAR
          123
        SRC
      end

      it { is_expected.to eq [] }
    end
  end
end
