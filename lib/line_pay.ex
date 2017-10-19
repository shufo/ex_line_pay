defmodule LinePay do
  @moduledoc """
  Documentation for ExLinePay.
  """

  # Let's build on top of HTTPoison
  use HTTPoison.Base
  use Retry

  @default_httpoison_options [
    timeout: 30000,
    recv_timeout: 80000,
  ]

  defmodule MissingChannelIdError do
    defexception message: """
      The channel_id setting is required so that we can report the
      correct environment instance to LinePay. Please configure
      channel_id in your config.exs and environment specific config files
      to have accurate reporting of errors.
      config :line_pay, channel_id: YOUR_SECRET_KEY
    """
  end

  defmodule MissingSecretKeyError do
    defexception message: """
      The channel_secret_key setting is required so that we can report the
      correct environment instance to LinePay. Please configure
      channel_secret_key in your config.exs and environment specific config files
      to have accurate reporting of errors.
      config :line_pay, channel_secret_key: YOUR_SECRET_KEY
    """
  end

  def config_or_env_channel_id do
    require_line_pay_channel_id()
  end

  @doc """
  Grabs LINE_PAY_CHANNEL_SECRET_KEY from system ENV
  Returns binary
  """
  def config_or_env_key do
    require_line_pay_key()
  end

  @doc """
  Creates the URL for our endpoint.
  Args:
    * endpoint - part of the API we're hitting
  Returns string
  """
  def process_url(endpoint) do
    if sandbox?() do
      "https://sandbox-api-pay.line.me/v2/" <> endpoint
    else
      "https://api-pay.line.me/v2/" <> endpoint
    end
  end

  defp sandbox? do
    case Application.get_env(:ex_line_pay, :sandbox, System.get_env "LINE_PAY_SANDBOX") do
      "true"  -> true
      "false" -> false
      true    -> true
      false   -> false
      nil     -> false
      _       -> false
    end
  end

  @doc """
  Set our request headers for every request.
  """
  def req_headers(channel_id, key) do
    Map.new
      |> Map.put("X-LINE-ChannelId", "#{channel_id}")
      |> Map.put("X-LINE-ChannelSecret", "#{key}")
      |> Map.put("User-Agent",    "LinePay/v2 ex_line_pay/0.1.0")
      |> Map.put("Content-Type",  "application/json")
  end

  @doc """
  Converts the binary keys in our response to atoms.
  Args:
    * body - string binary response
  Returns Record or ArgumentError
  """
  def process_response_body(body) do
    Poison.decode! body
  end

  @doc """
  Boilerplate code to make requests with a given key.
  Args:
    * method - request method
    * endpoint - string requested API endpoint
    * key - line_pay key passed to the api
    * body - request body
    * headers - request headers
    * options - request options
  Returns tuple
  """
  def make_request_with_key(method, endpoint, channel_id, key, body \\ %{}, headers \\ %{}, options \\ []) do
    rb = body |> Poison.encode!
    rh = req_headers(channel_id, key)
        |> Map.merge(headers)
        |> Map.to_list

    options = Keyword.merge(httpoison_request_options(), options)
    {:ok, response} = retry with: exp_backoff() |> randomize() |> expiry(60_000) do
      request(method, endpoint, rb, rh, options)
    end
    response.body
  end

  @doc """
  Boilerplate code to make requests with the key read from config or env.see config_or_env_key/0
  Args:
  * method - request method
  * endpoint - string requested API endpoint
  * key - line_pay key passed to the api
  * body - request body
  * headers - request headers
  * options - request options
  Returns tuple
  """
  def make_request(method, endpoint, body \\ %{}, headers \\ %{}, options \\ []) do
    make_request_with_key( method, endpoint, config_or_env_channel_id(), config_or_env_key(), body, headers, options )
  end

  defp require_line_pay_key do
    case Application.get_env(:line_pay, :channel_secret_key, System.get_env "LINE_PAY_CHANNEL_SECRET_KEY") || :not_found do
      :not_found ->
        raise MissingSecretKeyError
      value -> value
    end
  end

  defp require_line_pay_channel_id do
    case Application.get_env(:line_pay, :channel_id, System.get_env "LINE_PAY_CHANNEL_ID") || :not_found do
      :not_found ->
        raise MissingChannelIdError
      value -> value
    end
  end

  defp httpoison_request_options() do
    @default_httpoison_options
    |> Keyword.merge(Application.get_env(:line_pay, :httpoison_options, []))
  end
end
