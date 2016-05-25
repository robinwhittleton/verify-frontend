require 'feature_helper'
require 'api_test_helper'

RSpec.describe 'When the user visits the redirect to service page' do
  before(:each) do
    set_session_cookies!
    # page.set_rack_session(transaction_simple_id: 'test-rp')
  end

  context 'without javascript' do
    it 'will show a continue button' do
      visit redirect_signing_in_path

      api_request = stub_request(:get, api_url('/session/response-for-rp')).to_return({})
      expect(page).to have_title('Please wait. Signing you in')

      click_button 'Continue'
      expect(page).to have_current_path('/test-rp')
      expect(api_request).to have_been_made.once
    end
  end
end
