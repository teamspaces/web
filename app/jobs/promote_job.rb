class PromoteJob < ActiveJob::Base
  def perform(data)
    Shrine::Attacher.promote(data)
  end
end
