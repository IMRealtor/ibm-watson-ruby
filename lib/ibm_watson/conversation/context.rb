module IBMWatson
  module Conversation
    class Context < IBMWatson::BaseModel
      attribute :conversation_id
      attribute :dialog_stack, default: [{ dialog_node: "root" }]
      attribute :dialog_turn_counter, default: 1
      attribute :dialog_request_counter, default: 1
      attribute :context, default: {}
      attribute :_node_output_map

      def as_json(*)
        {
          conversation_id: conversation_id,
          system: {
            dialog_stack: dialog_stack,
            dialog_turn_counter: dialog_turn_counter,
            dialog_request_counter: dialog_request_counter,
          }
        }
      end

      def from_json(json)
        values = json.deep_symbolize_keys
        self.attributes= {
          conversation_id: values[:conversation_id],
          dialog_stack: values[:system][:dialog_stack],
          dialog_turn_counter: values[:system][:dialog_turn_counter],
          dialog_request_counter: values[:system][:dialog_request_counter],
          _node_output_map: values[:system][:_node_output_map],
          context: values[:context]
        }
      end
    end
  end
end
