class Reconomic::Session
  attr_reader :agreement_grant_token, :app_secret_token

  # Connect/authenticate with an API token and app id
  #
  # Reference: https://restdocs.e-conomic.com/#tl-dr
  def connect_with_token(app_secret_token, agreement_grant_token)
    @agreement_grant_token = agreement_grant_token
    @app_secret_token = app_secret_token
  end

  def get(path)
    response = authenticated_request.get(url(path))
    raise Reconomic::EconomicError, response.status.to_s unless response.status.success?
    response.body.to_s
  end

  def hostname
    URI.parse("https://restapi.e-conomic.com")
  end

  def post(path, body)
    response = authenticated_request.post(
      url(path),
      body: body
    )
    raise response.body.to_s unless response.status.success?
    response.body.to_s
  end

  def put(path, body)
    response = authenticated_request.put(
      url(path),
      body: body
    )
    raise response.body.to_s unless response.status.success?
    response.body.to_s
  end

  private

  def authenticated_request
    HTTP
      .headers({
        :content_type => "application/json",
        "X-AgreementGrantToken" => agreement_grant_token,
        "X-AppSecretToken" => app_secret_token
      })
  end

  def url(path)
    hostname + path
  end
end
