# frozen_string_literal: true

RSpec.describe Koltira::DynamoDB::Deserializer do
  it "has a version number" do
    expect(Koltira::DynamoDB::Deserializer::VERSION).not_to be nil
  end

  it "does something useful" do
    deserializer = Koltira::DynamoDB::Deserializer.new
    deserializer.call(
      {
        'Message' => { 'S' => 'This item has changed' },
        'Id' => { 'N' => '101' },
        'MyList' => {
          'L' => [
            { 'N' => '101' },
            { 'N' => '101' },
            { 'L' => [{ 'S' => 'SubListItem' }] },
            {
              'M' => {
                'Test' => { 'S' => 'String' },
                'SubBinarySet' => { 'BS' => ['bXkgc3VwZXIgc2VjcmV0IHRleHQh==', 'bXkgc3VwZXIgc2VjcmV0IHRleHQh=='] }
              }
            },
            { 'BS' => ['bXkgc3VwZXIgc2VjcmV0IHRleHQh==', 'bXkgc3VwZXIgc2VjcmV0IHRleHQh=='] }
          ]
        },
        'BinaryData' => { 'B' => 'bXkgc3VwZXIgc2VjcmV0IHRleHQh==' },
        'BinaryDataSet' => { 'BS' => ['bXkgc3VwZXIgc2VjcmV0IHRleHQh==', 'bXkgc3VwZXIgc2VjcmV0IHRleHQh=='] },
        'StringSet' => { 'SS' => ['toto', 'tata'] },
        'NumberSet' => { 'NS' => ['0.15778987', '187.45789978'] },
        'NullField' => { 'NULL' => true },
        'TrueBooleanField' => { 'BOOL' => true },
        'FalseBooleanField' => { 'BOOL' => false }
      }
    )
  end
end
