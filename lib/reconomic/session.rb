class Reconomic::Session
  attr_reader :agreement_grant_token, :app_secret_token

  # Connect/authenticate with an API token and app id
  #
  # Reference: https://restdocs.e-conomic.com/#tl-dr
  def connect_with_token(app_secret_token, agreement_grant_token)
    @agreement_grant_token = agreement_grant_token
    @app_secret_token = app_secret_token
  end
end
