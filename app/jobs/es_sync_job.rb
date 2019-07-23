require('ESrequest')

class EsSyncJob < ApplicationJob
  queue_as :low

  def perform(doc)
    ESrequest(:post,doc)
  end
end
