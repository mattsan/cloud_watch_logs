require 'cloud_watch_logs/version'
require 'cloud_watch_logs/log_group'

require 'aws-sdk-cloudwatchlogs'

class CloudWatchLogs
  REGION = 'ap-northeast-1'

  class Error < StandardError; end

  class Millisec
    def self.from_time(time)
      new((time.to_f * 1_000).floor)
    end

    def initialize(millisec)
      @millisec = millisec
    end

    def to_time
      Time.at(@millisec / 1_000.0)
    end

    def to_i
      @millisec
    end
  end

  def initialize(region: REGION, profile: nil)
    @client = Aws::CloudWatchLogs::Client.new(region: region, profile: profile)
  end

  def log_groups
    log_groups = describe_log_groups

    log_groups.map {|log_group|
      LogGroup.new(
        self,
        arn: log_group.arn,
        creation_time: log_group.creation_time,
        log_group_name: log_group.log_group_name,
        metric_filter_count: log_group.metric_filter_count,
        stored_bytes: log_group.stored_bytes,
        kms_key_id: log_group.kms_key_id
      )
    }
  end

  def events(log_group, start_time:, end_time:, filter:)
    raw_events = filter_log_events(
      log_group_name: log_group.log_group_name,
      start_time: Millisec.from_time(start_time).to_i,
      end_time: Millisec.from_time(end_time).to_i,
      filter_pattern: filter
    )

    raw_events.sort_by(&:timestamp).map {|raw|
      Event.new(
        log_stream_name: raw.log_stream_name,
        timestamp: Millisec.new(raw.timestamp).to_time,
        message: raw.message,
        ingestion_time: Millisec.new(raw.ingestion_time).to_time,
        event_id: raw.event_id
      )
    }
  end

  private

  def describe_log_groups
    next_token = nil

    log_groups = []
    loop do
      response = @client.describe_log_groups(next_token: next_token)
      log_groups.concat(response.log_groups)
      next_token = response.next_token
      break if next_token.nil?
    end

    log_groups
  end

  def filter_log_events(**params)
    params = params.slice(
      :log_group_name,
      :log_stream_names,
      :log_stream_name_prefix,
      :start_time,
      :end_time,
      :filter_pattern
    )

    events = []
    loop do
      response = @client.filter_log_events(params)
      events.concat(response.events)

      break if response.next_token.nil?
      params[:next_token] = response.next_token
    end

    events
  end
end
