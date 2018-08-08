RSpec.describe AstSearch do
  it "has a version number" do
    expect(AstSearch::VERSION).not_to be nil
  end

  describe ".find_external_classes" do
    subject(:result) { described_class.find_external_classes(src) }

    class ExternalClass
    end

    module SomeModule
      class NameSpacedClass
      end
    end

    let(:src) do
      <<~SRC
        class RootClass
          class InternalClass
          end
          module SomeModule
            class AnotherNameSpacedClass
            end
          end

          InternalClass
          ExternalClass
          SomeModule::NameSpacedClass
          SomeModule::AnotherNameSpacedClass
        end
      SRC
    end

    it "detects classes defined outside of the parsed code" do
      expect(result).to eq [ExternalClass, SomeModule::NameSpacedClass]
    end
  end
end
