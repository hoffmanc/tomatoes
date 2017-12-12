Capybara.save_and_open_page_path = Rails.root.join("tmp")

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
end

