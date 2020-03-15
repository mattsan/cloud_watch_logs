class CloudWatchLogs
  class Event
    attr_reader :log_stream_name, :timestamp, :message, :ingestion_time, :event_id

    def initialize(log_stream_name:, timestamp:, message:, ingestion_time:, event_id:)
      @log_stream_name = log_stream_name
      @timestamp = timestamp
      @message = message
      @ingestion_time = ingestion_time
      @event_id = event_id
    end
  end
end
