defmodule LinePay.Payments do
  @moduledoc """
  Functions for working with payments at Line Pay. Through this API you can: * get an account,
  LinePay API reference: https://pay.line.me/jp/developers/documentation/download/tech?locale=ja_JP
  """

  @endpoint "payments"

  @doc """
  Get a payment.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.Payments.get(transactionId: 2017101800001000)

  """
  def get(params \\ []) do
    get LinePay.config_or_env_channel_id, LinePay.config_or_env_key, params
  end

  @doc """
  Get a payment. Accepts Line Pay Channel Id and API key.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.Payments.get("channel_id", "my_key", transactionId: 2017101800001000)

  """
  def get(channel_id, key, params) do
    LinePay.make_request_with_key(:get, "#{@endpoint}", channel_id, key, %{}, %{}, params: params)
    |> LinePay.Util.handle_line_pay_response
  end


  @doc """
  Reserve a payment.

  Reserve a payment.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.Payments.reserve(%{amount: 1000, confirmUrl: "myapp://line_pay", currency: "JPY", orderId: "#1", productName: "foobar"})

  """
  def reserve(params) do
    reserve LinePay.config_or_env_channel_id, LinePay.config_or_env_key, params
  end

  @doc """
  Reserve a payment.

  Reserve a payment.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.Payments.reserve("channel_id", "api_key", %{amount: 1000, confirmUrl: "myapp://line_pay", currency: "JPY", orderId: "#1", productName: "foobar"})

  """
  def reserve(channel_id, key, params) do
    LinePay.make_request_with_key(:post, "#{@endpoint}/request", channel_id, key, params)
    |> LinePay.Util.handle_line_pay_response
  end

  @doc """
  Confirm a payment.

  Confirms a payment.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.Payments.confirm("transaction_id", %{amount: 1000, currency: "JPY"})

  """
  def confirm(transaction_id, params) do
    confirm LinePay.config_or_env_channel_id, LinePay.config_or_env_key, transaction_id, params
  end

  @doc """
  Confirm a payment.

  Confirms a payment.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.Payments.confirm("channel_id", "api_key", "transaction_id", %{amount: 1000, currency: "JPY"})

  """
  def confirm(channel_id, key, transaction_id, params) do
    LinePay.make_request_with_key(:post, "#{@endpoint}/#{transaction_id}/confirm", channel_id, key, params)
    |> LinePay.Util.handle_line_pay_response
  end

  @doc """
  Invalidate a authorized payment.

  Invalidates a authorized payment.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.Payments.void("transaction_id")

  """
  def void(transaction_id) do
    void LinePay.config_or_env_channel_id, LinePay.config_or_env_key, transaction_id
  end

  @doc """
  Invalidate a authorized payment.

  Invalidates a authorized payment.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.Payments.void("channel_id", "api_key", "transaction_id")

  """
  def void(channel_id, key, transaction_id) do
    LinePay.make_request_with_key(:post, "#{@endpoint}/authorizations/#{transaction_id}/void", channel_id, key)
    |> LinePay.Util.handle_line_pay_response
  end

  @doc """
  Refund a authorized payment.

  Refunds a authorized payment.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.Payments.refund("transaction_id")
      {:ok, payment} = LinePay.Payments.refund("transaction_id", %{refundAmount: 500})

  """
  def refund(transaction_id, params \\ %{}) do
    refund LinePay.config_or_env_channel_id, LinePay.config_or_env_key, transaction_id, params
  end

  @doc """
  Refund a authorized payment.

  Refunds a authorized payment.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.Payments.refund("channel_id", "my_key", "transaction_id")
      {:ok, payment} = LinePay.Payments.refund("channel_id", "my_key", "transaction_id", %{refundAmount: 500})

  """
  def refund(channel_id, key, transaction_id, params) do
    LinePay.make_request_with_key(:post, "#{@endpoint}/#{transaction_id}/refund", channel_id, key, params)
    |> LinePay.Util.handle_line_pay_response
  end

  @doc """
  Capture a payment.

  Captures a payment that is currently pending.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.Payments.capture("transaction_id", %{amount: 1000, currency: "JPY"})

  """
  def capture(transaction_id, params \\ %{}) do
    capture LinePay.config_or_env_channel_id, LinePay.config_or_env_key, transaction_id, params
  end

  @doc """
  Capture a payment.

  Captures a payment that is currently pending.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.Payments.capture("channel_id", "my_key", "transaction_id", %{amount: 1000, currency: "JPY"})

  """
  def capture(channel_id, key, transaction_id, params) do
    LinePay.make_request_with_key(:post, "#{@endpoint}/authorizations/#{transaction_id}/capture", channel_id, key, params)
    |> LinePay.Util.handle_line_pay_response
  end
end
