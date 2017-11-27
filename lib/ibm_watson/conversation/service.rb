module IBMWatson
  module Conversation
    class Service < IBMWatson::BaseService
      version "v1"
      url "https://gateway.watsonplatform.net/conversation/api"
      QUERY_VERSION = "2017-02-03"

      def workspace(workspace_id:, export: false)
        handle_timeout do
          result = get "workspaces/#{workspace_id}", version: QUERY_VERSION, export: export
          IBMWatson::Conversation::Workspace.new(result)
        end
      end


      def list_workspaces
        handle_timeout do
          result = get 'workspaces', { version: QUERY_VERSION }
          result['workspaces'].map do |workspace_json|
            IBMWatson::Conversation::Workspace.new(workspace_json)
          end
        end
      end

      def create_workspace(workspace_data:)
        handle_timeout do
          upload_workspace('workspaces', workspace_data)
        end
      end

      def delete_workspace(workspace_id:)
        handle_timeout do
          delete "workspaces/#{workspace_id}?version=#{QUERY_VERSION}"
        end
      end

      def update_workspace(workspace_id:, workspace_data:)
        handle_timeout do
          upload_workspace("workspaces/#{workspace_id}", workspace_data)
        end
      end

      def message(workspace_id:, input:, context:, alternate_intents: false)
        handle_timeout do
          params = {
            input: { text: input },
            context: context.as_json,
            alternate_intents: alternate_intents
          }
          result = post "workspaces/#{workspace_id}/message?version=#{QUERY_VERSION}", params
          IBMWatson::Conversation::MessageResponse.new(result)
        end
      end

      def create_example(workspace_id:, intent:, example:)
        handle_timeout do
          params = {
            text: example
          }
          result = post "workspaces/#{workspace_id}/intents/#{intent}/examples?version=#{QUERY_VERSION}", params
          IBMWatson::Conversation::CreateExampleResponse.new(result)
        end
      end

      private

      def upload_workspace(url, workspace_data)
        result = post "#{url}?version=#{QUERY_VERSION}", workspace_data
        IBMWatson::Conversation::Workspace.new(result)
      end
    end
  end
end
