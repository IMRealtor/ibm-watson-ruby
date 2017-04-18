require 'spec_helper'
require 'ibm_watson'

describe IBMWatson::NLU::Service, record: :once do
  subject(:service) { described_class.new(username: username, password: password) }
  let(:username) { ENV['IBM_WATSON_NLU_USERNAME'] }
  let(:password) { ENV['IBM_WATSON_NLU_PASSWORD'] }

  describe "keyword extraction" do
    example do
      result = service.analyze_text("sure, I'll bite. My name is Kieran", keywords: true)

      expect(result.keywords).to be_a_kind_of(Array)
      expect(result.keywords.length).to eq(1)
      expect(result.keywords[0].as_json).to eq({ "relevance" => 0.970239, "text" => "Kieran" })
    end
  end
end
