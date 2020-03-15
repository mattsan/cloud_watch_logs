require 'cloud_watch_logs/event'

class CloudWatchLogs
  class LogGroup
    # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/CloudWatchLogs/Types/LogGroup.html

    attr_reader :arn, :creation_time, :log_group_name, :metric_filter_count, :stored_bytes, :kms_key_id

    def initialize(cloud_watch_logs, arn:, creation_time:, log_group_name:, metric_filter_count:, stored_bytes:, kms_key_id:)
      @cloud_watch_logs = cloud_watch_logs

      @arn = arn
      @creation_time = creation_time
      @log_group_name = log_group_name
      @metric_filter_count = metric_filter_count
      @stored_bytes = stored_bytes
      @kms_key_id = kms_key_id
    end

    def events(start_time:, end_time:, filter: nil)
      @cloud_watch_logs.events(
        self,
        start_time: start_time,
        end_time: end_time,
        filter: filter
      )
    end
  end
end
