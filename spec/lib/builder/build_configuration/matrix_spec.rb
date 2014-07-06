require 'spec_helper'

describe Vx::Builder::BuildConfiguration::Matrix do
  let(:params) { { 'matrix' => ['a', 'b'], 'global' => ['c', 'd'] } }
  let(:env)    { described_class.new params }
  subject { env }

  it "should succeefuly work without matrix" do
    matrix = described_class.new(nil)
    expect(matrix.attributes).to be_empty

    matrix = described_class.new({})
    expect(matrix.attributes).to be_empty

    matrix = described_class.new({"foo" => "bar"})
    expect(matrix.attributes).to be_empty

    matrix = described_class.new(%w{1})
    expect(matrix.attributes).to be_empty

    matrix = described_class.new('string')
    expect(matrix.attributes).to be_empty
  end

  it "should build exclude attribute from Hash" do
    attrs = {
      "exclude" => {
        "rvm" => "2.1"
      }
    }

    matrix = described_class.new attrs
    expect(matrix.attributes).to eq({
      "exclude"=> [{"rvm" => "2.1"}]
    })
    expect(matrix.exclude).to eq([{'rvm' => '2.1'}])
  end

  it "should build exclude attribute from Array" do
    attrs = {
      "exclude" => [
        {"rvm" => "2.1"},
        'ignore'
      ]
    }
    matrix = described_class.new attrs
    expect(matrix.attributes).to eq({
      "exclude"=> [{"rvm" => "2.1"}]
    })
    expect(matrix.exclude).to eq([{'rvm' => '2.1'}])
  end
end
