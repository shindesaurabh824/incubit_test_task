# frozen_string_literal: true

class EmailWorker
  include Sidekiq::Worker

  def perform(method_name, email, delivery)
    UserMailer.send(method_name.to_sym, email).send(delivery.to_sym)
  end
end
