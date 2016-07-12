require 'originating_ip_store'

Rails.application.config.after_initialize do
  FEDERATION_TRANSLATOR = Display::FederationTranslator.new
  API_HOST = CONFIG.api_host
  api_client = Api::Client.new(API_HOST, Api::ResponseHandler.new)

  SESSION_PROXY = SessionProxy.new(api_client, OriginatingIpStore)
  TRANSACTION_LISTER = Display::Rp::TransactionLister.new(
    Display::Rp::TransactionsProxy.new(api_client),
    Display::Rp::DisplayDataCorrelator.new(FEDERATION_TRANSLATOR)
  )
end
