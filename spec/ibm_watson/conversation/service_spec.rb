require 'spec_helper'
require 'ibm_watson'

describe IBMWatson::Conversation::Service, record: :none do
  subject(:service) { described_class.new(username: username, password: password) }
  let(:username) { ENV['IBM_WATSON_CONVERSATION_USERNAME'] }
  let(:password) { ENV['IBM_WATSON_CONVERSATION_PASSWORD'] }
  let(:workspace_id) { ENV['IBM_WATSON_WORKSPACE_ID'] }
  subject(:service) do
    described_class.new(username: username, password: password)
  end

  describe "#message" do
    let(:expected_intents) { [{ "intent" => "express_delight", "confidence" => 0.99 }] }
    let(:expected_context_json) { { "conversation_id" => "b90a141a-14b0-48b5-aad3-f53454e93444",
                                    "system" => { "dialog_stack" => [{ "dialog_node" => "Introduce the Bot" }],
                                                  "dialog_turn_counter" => 1, "dialog_request_counter" => 1 },
                                    "listing" => "none", "introduced" => true, "initial_question" => "Awesome!" } }
    let(:expected_output_json) { {"log_messages"=>[], "text"=>[], "nodes_visited"=>["Conversation Starts", "Introduce the Bot"], "message_template"=>"realtor/intro",
                                  "choices"=>{"choices"=>[{"body"=>"Like this?"}], "template"=>"realtor/intro_question_one"}, "template"=>"realtor/intro"} }
    let(:conversation_id) { "b90a141a-14b0-48b5-aad3-f53454e93444" }
    let(:context) {
      { conversation_id: conversation_id }
    }


    example do
      result = subject.message(workspace_id: workspace_id, input: "Awesome!", context: context)
      expect(result.intents.first).to be_a_kind_of(IBMWatson::Conversation::IntentResult)
      expect(result.intents.as_json).to eq expected_intents
      expect(result.context).to be_a_kind_of(Hash)
      expect(result.context.as_json).to eq(expected_context_json)
      expect(result.output).to be_a_kind_of(Hash)
      expect(result.output.as_json).to eq(expected_output_json)
    end
  end

  describe "#workspace", record: :all do
    example do
      result = subject.workspace(workspace_id: workspace_id, export: true)
      expect(result.intents.first).to be_a_kind_of(IBMWatson::Conversation::Intent)
      expect(result.dialog_nodes.first).to be_a_kind_of(IBMWatson::Conversation::DialogNode)
    end
  end
end
