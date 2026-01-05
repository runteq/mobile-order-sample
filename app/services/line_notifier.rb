require "net/http"
require "uri"
require "json"

class LineNotifier
  API_ENDPOINT = "https://api.line.me/v2/bot/message/push"

  def initialize
    @channel_access_token = ENV["LINE_CHANNEL_ACCESS_TOKEN"]
  end

  def order_created(order)
    return unless @channel_access_token.present?

    message = <<~MSG
      ご注文ありがとうございます！

      注文番号: ##{order.id}
      合計: ¥#{order.total_price_yen}

      注文内容:
      #{order.order_items.map { |i| "・#{i.product.name} x#{i.qty}" }.join("\n")}

      ※これはデモ注文です
    MSG

    push_message(order.user.line_user_id, message.strip)
  end

  def order_ready(order)
    return unless @channel_access_token.present?

    message = <<~MSG
      ご注文の準備ができました！

      注文番号: ##{order.id}

      ※これはデモ注文です
    MSG

    push_message(order.user.line_user_id, message.strip)
  end

  private

  def push_message(line_user_id, text)
    return unless @channel_access_token.present?

    uri = URI.parse(API_ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{@channel_access_token}"
    request.body = {
      to: line_user_id,
      messages: [
        { type: "text", text: text }
      ]
    }.to_json

    begin
      response = http.request(request)
      Rails.logger.info "LINE notification sent: #{response.code}"
    rescue => e
      Rails.logger.error "LINE notification failed: #{e.message}"
    end
  end
end
