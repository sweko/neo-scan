defmodule NeoscanCache.Api do
  @moduledoc """
  Interface between server and worker to communicate with external modules
  """
  alias NeoscanCache.Server
  alias Neoscan.ChainAssets

  def get_blocks do
    Server.get(:blocks)
  end

  def get_transfers do
    Server.get(:transfers)
  end

  def get_transactions do
    Server.get(:transactions)
  end

  def get_assets do
    assets = Server.get(:assets)
    if is_nil(assets), do: [], else: assets
  end

  def get_asset(hash) do
    Server.get(:assets)
    |> Enum.find(fn %{:txid => txid} -> txid == hash end)
  end

  def get_asset_name(hash) do
    cond do
      String.length(hash) == 40 ->
        Server.get(:assets)
        |> Enum.find(fn %{:contract => contract} -> contract == hash end)
        |> Map.get(:name)
        |> ChainAssets.filter_name()

      true ->
        Server.get(:assets)
        |> Enum.find(fn %{:txid => txid} -> txid == hash end)
        |> Map.get(:name)
        |> ChainAssets.filter_name()
    end
  end

  def check_asset(hash) do
    Server.get(:assets)
    |> Enum.any?(fn %{:txid => txid} -> txid == hash end)
  end

  def get_addresses do
    Server.get(:addresses)
  end

  def get_contracts do
    Server.get(:contracts)
  end

  def get_price do
    Server.get(:price)
  end

  def get_stats do
    Server.get(:stats)
  end
end
