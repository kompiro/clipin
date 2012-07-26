def mock_auth
  create(:user)
  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:facebook,{
    :provider => 'facebook',
    :uid => '1234',
    :extra => {}
  })
end
