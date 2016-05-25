class RedirectToServiceController < ApplicationController
  def signing_in
    @saml_message = SESSION_PROXY.response_from_rp(cookies)
  end
end
