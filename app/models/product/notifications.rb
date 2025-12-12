module Product::Notifications extend ActiveSupport::Concern
  included do
    has_many :subscribers, dependent: :destroy
    after_update_commit :notify_subscribers, if: :back_in_stock?
  end

  def back_in_stock?
    inventory_count_previously_was.zero? && inventory_count.positive?
  end

  def notify_subscribers
    subscribers.each do |subscribers|
      ProductMailer.with(product: self, subscriber: subscriber).in_stock.deliver_layer
    end
  end
end

