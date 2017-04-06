require 'spec_helper'
require 'ibm_watson'

describe IBMWatson::Conversation::Service, record: :none do
  subject(:service) { described_class.new(username: username, password: password) }
  let(:username) { ENV['IBM_WATSON_CONVERSATION_USERNAME'] }
  let(:password) { ENV['IBM_WATSON_CONVERSATION_PASSWORD'] }
  let(:workspace_id) { ENV['IBM_WATSON_WORKSPACE_ID'] }
  let(:delete_workspace_id) { ENV['IBM_WATSON_WORKSPACE_ID_TO_DELETE'] }
  subject(:service) do
    described_class.new(username: username, password: password)
  end

  describe "#message" do
    before do
      data = YAML.load_file('spec/assets/poc_workspace.json')
      subject.update_workspace(workspace_id: workspace_id, workspace_data: data)
    end

    let(:expected_intents) { [{ "intent" => "express_delight", "confidence" => 0.99 }] }
    let(:expected_context_json) { { "conversation_id" => "b90a141a-14b0-48b5-aad3-f53454e93444",
                                    "system" => { "dialog_stack" => [{ "dialog_node" => "Introduce the Bot" }],
                                                  "dialog_turn_counter" => 1, "dialog_request_counter" => 1 },
                                    "listing" => "none", "introduced" => true, "initial_question" => "Awesome!" } }
    let(:expected_output_json) { { "log_messages" => [], "text" => [], "nodes_visited" => ["Conversation Starts", "Introduce the Bot"], "message_template" => "realtor/intro",
                                   "choices" => { "choices" => [{ "body" => "Like this?" }], "template" => "realtor/intro_question_one" }, "template" => "realtor/intro" } }
    let(:conversation_id) { "b90a141a-14b0-48b5-aad3-f53454e93444" }
    let(:context) {
      { conversation_id: conversation_id }
    }
    let(:expected_result_json) { {
      "alternate_intents" => false,
      "context" => { "conversation_id" => "b90a141a-14b0-48b5-aad3-f53454e93444", "system" => { "dialog_stack" => [{ "dialog_node" => "Introduce the Bot" }], "dialog_turn_counter" => 1, "dialog_request_counter" => 1 }, "listing" => "none", "introduced" => true, "initial_question" => "Awesome!" },
      "entities" => [],
      "input" => { "text" => "Awesome!" },
      "intents" => [{ "intent" => "express_delight", "confidence" => 0.99 }],
      "output" => { "log_messages" => [], "text" => [], "nodes_visited" => ["Conversation Starts", "Introduce the Bot"], "message_template" => "realtor/intro", "choices" => { "choices" => [{ "body" => "Like this?" }], "template" => "realtor/intro_question_one" }, "template" => "realtor/intro" }
    } }


    example do
      result = subject.message(workspace_id: workspace_id, input: "Awesome!", context: context)
      expect(result.intents.first).to be_a_kind_of(IBMWatson::Conversation::IntentResult)
      expect(result.intents.as_json).to eq expected_intents
      expect(result.context).to be_a_kind_of(Hash)
      expect(result.context.as_json).to eq(expected_context_json)
      expect(result.output).to be_a_kind_of(Hash)
      expect(result.output.as_json).to eq(expected_output_json)
      expect(result.as_json).to eq(expected_result_json)
    end
  end

  describe "#list_workspaces" do
    let(:expected_count) { 8 }
    example do
      result = subject.list_workspaces
      expect(result.first).to be_a_kind_of(IBMWatson::Conversation::Workspace)
      expect(result.count).to eq expected_count
    end
  end

  describe "#workspace" do
    example do
      result = subject.workspace(workspace_id: workspace_id, export: true)
      expect(result.intents.first).to be_a_kind_of(IBMWatson::Conversation::Intent)
      expect(result.dialog_nodes.first).to be_a_kind_of(IBMWatson::Conversation::DialogNode)
    end
  end

  describe "#update_workspace" do
    example do
      result = subject.workspace(workspace_id: workspace_id, export: true)
      workspace = {
        intents: result.intents.map(&:as_json),
        entities: result.entities.map(&:as_json),
        dialog_nodes: result.dialog_nodes.map(&:as_json),
      }
      subject.update_workspace(workspace_id: workspace_id, workspace_data: workspace)
    end
  end

  describe "#create_workspace" do
    example do
      result = subject.workspace(workspace_id: workspace_id, export: true)
      workspace = {
        name: 'IBM Watson Ruby Gem Spec Created Workspace',
        intents: result.intents.map(&:as_json),
        entities: result.entities.map(&:as_json),
        dialog_nodes: result.dialog_nodes.map(&:as_json),
      }
      subject.create_workspace(workspace_data: workspace)
    end
  end

  describe "#delete_workspace" do
    example do
       expect {
         subject.delete_workspace(workspace_id: delete_workspace_id)
       }.not_to raise_error
    end
  end
end
