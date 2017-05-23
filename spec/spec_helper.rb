require 'bundler/setup'
Bundler.require :default, :development
require 'dotenv/load'
require 'active_support/all'

RSpec.configure do |config|
  config.around(:each) do |test|
      stack = Middleware::Builder.new do |builder|
        if test.metadata[:timezone].present?
          builder.use RspecMiddlewares::Timezone, timezone: test.metadata[:timezone]
        end

        if test.metadata[:current_time].present?
          builder.use RspecMiddlewares::Timecop, current_time: test.metadata[:current_time]
        end

        if test.metadata[:freeze_time].present?
          builder.use RspecMiddlewares::Timecop, freeze_time: test.metadata[:freeze_time]
        end

        if test.metadata[:record].present?
          builder.use RspecMiddlewares::VCR,
                      cassette_name: test.metadata[:cassette_name],
                      record: test.metadata[:record],
                      match_requests_on: test.metadata[:match_requests_on]
        end
        builder.use RspecMiddlewares::Sidekiq if test.metadata[:run_jobs]
        builder.use RspecMiddlewares::Main
      end

      stack.call test: test
    end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock

  config.before_record do |interaction|
    interaction.request.headers.delete('Authorization')
    interaction.request.headers.delete('User-Agent')
    interaction.request.headers.delete('Accept-Encoding')
  end

  if ENV["DEBUG_VCR"]
    puts "Notice: VCR Debug mode enabled by DEBUG_VCR, see tmp/vcr-debug.log for the log."
    config.debug_logger = File.open("tmp/vcr-debug.log", 'w')
  end
end
