defmodule LinePay.PreapprovedPay do
  @moduledoc """
  Functions for working with accounts at LinePay. Through this API you can: * get an account,
  LinePay API reference: https://pay.jp/docs/api/#account-アカウント
  """

  @endpoint "payments/preapprovedPay"

  @doc """
  Create a pre approved payment.

  Creates a pre approved payment by reg key returned on Reserve API.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.PreapprovedPay.create("reg_key", %{productName: "foobar", amount: 1000, currency: "JPY", orderId: "#1"})
      {:ok, payment} = LinePay.PreapprovedPay.create("reg_key", %{productName: "foobar", amount: 1000, currency: "JPY", orderId: "#1", capture: false})

  """
  def create(reg_key, params \\ %{}) do
    create(LinePay.config_or_env_channel_id(), LinePay.config_or_env_key(), reg_key, params)
  end

  @doc """
  Create a pre approved payment.

  Creates a pre approved payment by reg key returned on Reserve API.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.PreapprovedPay.create("channel_id", "api_key", "reg_key", %{productName: "foobar", amount: 1000, currency: "JPY", orderId: "#1"})
      {:ok, payment} = LinePay.PreapprovedPay.create("channel_id", "api_key", "reg_key", %{productName: "foobar", amount: 1000, currency: "JPY", orderId: "#1", capture: false})

  """
  def create(channel_id, key, reg_key, params) do
    LinePay.make_request_with_key(
      :post,
      "#{@endpoint}/#{reg_key}/payment",
      channel_id,
      key,
      params
    )
    |> LinePay.Util.handle_line_pay_response()
  end

  @doc """
  Check a pre approved payment.

  Checks a pre approved payment.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.PreapprovedPay.check("reg_key")
      {:ok, payment} = LinePay.PreapprovedPay.check("reg_key", %{creditCardAuth: true})

  """
  def check(reg_key, params \\ []) do
    check(LinePay.config_or_env_channel_id(), LinePay.config_or_env_key(), reg_key, params)
  end

  @doc """
  Check a pre approved payment.

  Checks a pre approved payment.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.PreapprovedPay.check("channel_id", "my_key", "reg_key")
      {:ok, payment} = LinePay.PreapprovedPay.check("channel_id", "my_key", "reg_key", %{creditCardAuth: true})

  """
  def check(channel_id, key, reg_key, params) do
    LinePay.make_request_with_key(
      :get,
      "#{@endpoint}/#{reg_key}/check",
      channel_id,
      key,
      %{},
      %{},
      params: params
    )
    |> LinePay.Util.handle_line_pay_response()
  end

  @doc """
  Expire a pre approved payment.

  Expires a pre approved payment.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.PreapprovedPay.expire("reg_key")

  """
  def expire(reg_key) do
    expire(LinePay.config_or_env_channel_id(), LinePay.config_or_env_key(), reg_key)
  end

  @doc """
  Expire a pre approved payment.

  Expires a pre approved payment.

  Returns a `{:ok, payment}` tuple.

  ## Examples

      {:ok, payment} = LinePay.PreapprovedPay.expire("channel_id", "my_key", "reg_key")

  """
  def expire(channel_id, key, reg_key) do
    LinePay.make_request_with_key(:post, "#{@endpoint}/#{reg_key}/expire", channel_id, key)
    |> LinePay.Util.handle_line_pay_response()
  end
end
