# ExLinePay

A LINE Pay client for Elixir.

## Installation

```elixir
def deps do
  [
    {:ex_line_pay, "~> 0.1.0"}
  ]
end
```

## Usage

### Set your credentials

ex_line_pay defaults to try read credentials from environment variables or configuration.

```bash
export LINE_PAY_CHANNEL_ID=1234567890
export LINE_PAY_CHANNEL_SECRET_KEY=your_channel_secret_key
```

`config.exs`

```elixir
config :ex_line_pay, channel_id: "1234567890",
                  channel_secret_key: "your_channel_secret_key"
```

### Set environment

`dev.exs`

```elixir
config :ex_line_pay, sandbox: true
```

`prod.exs`

```elixir
config :ex_line_pay, sandbox: false
```

### Payment

- Reserve a payment

```elixir
# Proceed sales with capture
params = %{
  amount: 1000,
  confirmUrl: "myapp://line_pay",
  currency: "JPY",
  orderId: "#1",
  productName: "foobar"
}

{:ok, payment} = LinePay.Payments.reserve(params)

# If you want to separate the authorization process, specify `capture` to `false`.
params = %{
  amount: 1000,
  confirmUrl: "myapp://line_pay",
  currency: "JPY",
  orderId: "#1",
  productName: "foobar",
  capture: false
}

{:ok, payment} = LinePay.Payments.reserve(params)
```

- Confirm a payment

```elixir
params = %{amount: 1000, currency: "JPY"}

{:ok, payment} = LinePay.Payments.confirm("transaction_id", params)
```

- Capture a payment

```elixir

params = %{amount: 1000, currency: "JPY"}

{:ok, payment} = LinePay.Payments.capture("transaction_id", params)
```

- Refund a payment

```elixir
{:ok, payment} = LinePay.Payments.refund("transaction_id")
```

- Partially refund a payment

```elixir
{:ok, payment} = LinePay.Payments.refund("transaction_id", %{refundAmount: 500})
```

- Invalidate the authorized payment

```elixir
{:ok, payment} = LinePay.Payments.void("transaction_id")
```

- Get payments detail.

```elixir
# Get payments by transaction id
{:ok, payment} = LinePay.Payments.get(transactionId: 2017101800001000)

# Get payments by order id
{:ok, payment} = LinePay.Payments.get(orderId: "#5")

# You can specify both transaction id and order id
{:ok, payment} = LinePay.Payments.get(orderId: "#5", transactionId: 2017101800001000)
```

## TODO

- [ ] Add VCR Tests

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

MIT
