class ApplicationJob < ActiveJob::Base
  queue_as :default

  # def perform(*args)
  #   # Perform Job
  # end
  #
  # rescue_from(ErrorLoadingSite) do
  #   retry_job wait: 5.minutes, queue: :low_priority
  # end
  #
  # rescue_from ActiveJob::DeserializationError do |exception|
  #   # handle a deleted user record
  # end
end
