class OrderNotifierMailer < ApplicationMailer
  default from: 'sam Ruby <depot@example.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier_mailer.received.subject
  #
  def received(example)
    @example = example

    mail to: @example.email, subject: "Nakagawa's Bookshelf order confirmation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier_mailer.shipped.subject
  #
  def shipped(example)
    @example = example

    mail to: @example.email, subject: "Nakagawa's Bookshelf Order Shipped"
  end
end
