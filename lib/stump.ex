defmodule Stump do
  @moduledoc """
  Stump allows for Maps and Strings to be passed into the Elixir Logger and return logs in the JSON format.
  """
  @moduledoc since: "1.0.0"
  @doc """
  The `log` method formats your given error message whether it be a Map or a String then passes it to Elixirs own Logger.

  Usage for the module is as follows:

  ```
  Stump.log(:level, message)
  ```

  The level can be any of four `:debug/:info/:warn/:error`


  Message can be either a `String` or `Map`

  ```
    Stump.log(:error, 'Error Logged')
    {'message':'Error Logged','level':'error','datetime':'2019-03-06T12:21:52.661587Z'}
  ```
  """
  import Logger, only: [log: 2]

  def log(level, data) when level in [:error, :warn, :info] do
    Logger.log(level, format(level, data))
  end

  defp format(level, data) when data == nil or data == "" do
    format(level, "Event Logger received log level, but no error message was provided")
  end

  defp format(level, data) when is_map(data) do
    data
    |> Map.merge(%{datetime: time(), level: to_string(level)})
    |> Poison.encode!()
  end

  defp format(level, data) when is_bitstring(data) or is_binary(data) do
    %{message: data, datetime: time(), level: to_string(level)}
    |> Poison.encode!()
  end

  @doc false
  def time() do
    Application.get_env(:stump, :time_api).utc_now()
  end
end