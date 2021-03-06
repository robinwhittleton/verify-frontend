require 'rails_helper'
require 'controller_helper'
require 'api_test_helper'
require 'piwik_test_helper'

describe StartVariantCreateAccountController do
  before(:each) do
    stub_piwik_request_with_rp('action_name' => 'The user has reached the start page')
  end

  it 'renders LOA1 start page if service is level 1' do
    set_session_and_cookies_with_loa('LEVEL_1')
    stub_piwik_report_loa_requested('LEVEL_1')
    get :index, params: { locale: 'en' }
    expect(subject).to render_template(:start_loa1)
  end
end
