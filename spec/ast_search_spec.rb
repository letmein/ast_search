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

  describe ".find_class_definitions" do
    subject(:result) { described_class.find_class_definitions(src) }

    let(:src) do
      <<~SRC
        class Class1
          class Class2
          end
          module SomeModule
            class Class3
            end
          end
        end
      SRC
    end

    it "detects all class definitions" do
      expect(result).to eq %w[Class1 Class1::Class2 Class1::SomeModule::Class3]
    end
  end
end
