module IBMWatson
  module Conversation
    class Service < IBMWatson::BaseService
      version "v1"
      url "https://gateway.watsonplatform.net/conversation/api"
      QUERY_VERSION = "2017-02-03"

      def workspace(workspace_id:, export: false)
        url = build_url('workspaces', workspace_id, query: { version: QUERY_VERSION, export: export})
        result = accept_json(basic_auth).get(url)
        verify_http_result(result)
        IBMWatson::Conversation::Workspace.new.tap do |result_object|
          result_object.from_json(result)
        end
      end

      def message(workspace_id:, input:, context:, alternate_intents: false)
        url = build_url('workspaces',workspace_id, 'message', query: { version: QUERY_VERSION})
        params = {
          input: {text: input},
          context: context.as_json,
          alternate_intents: alternate_intents
        }
        result = accept_json(basic_auth).post(url, json: params)
        verify_http_result(result)
        IBMWatson::Conversation::Result.new.tap do |result_object|
          result_object.from_json(result)
        end
      end
    end
  end
end