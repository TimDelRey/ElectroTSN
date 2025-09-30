class GenerateReceiptJob
  include Sidekiq::Job

  sidekiq_options queue: :receipts, retry: 3

  def perform(receipt_id, date = nil)
    receipt = Receipt.find(receipt_id)

    receipt.processing!

    payload = {
      receipt_id: receipt.id,
      user_id: receipt.user_id,
      date: date || receipt.for_month,
      s3_key: receipt.xls_file.attached? ? receipt.xls_file.key : "no key"
      # upload_url:receipt.xls_file.blob.service_url_for_direct_upload(expires_in: 1.hour)
      # upload_url:receipt.xls_file.blob.presigned_url_without_length
    }

    redis.rpush("receipts:jobs", payload.to_json)
    Rails.logger.info "Receipt #{payload.inspect} pushed in Redis"
  rescue ActiveRecord::RecordNotFound
    Rails.logger.warn "Receipt ##{receipt_id} not found"
  end

  def redis
    @redis ||= Redis.new(url: ENV.fetch("REDIS_URL", "redis://redis:6379/0"))
  end
end
