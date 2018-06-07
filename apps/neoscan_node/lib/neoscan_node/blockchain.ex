defmodule NeoscanNode.Blockchain do
  @moduledoc """
  The boundary for the Blockchain requests.
  """

  alias NeoscanNode.HttpCalls
  alias NeoscanNode.NodeChecker

  @headers [{"Content-Type", "application/json"}, {"Accept-Encoding", "gzip"}]

  defp request(url, method, params) do
    data =
      Poison.encode!(%{
        "jsonrpc" => "2.0",
        "method" => method,
        "params" => params,
        "id" => 5
      })

    HttpCalls.request(@headers, data, url)
  end

  defp parse16(string) do
    string
    |> String.slice(-64..-1)
    |> String.upcase()
    |> Base.decode16!()
  end

  defp parse_block(block) do
    hash = block["hash"]

    tx =
      Enum.map(block["tx"], fn transaction ->
        transaction
        |> Map.put("hash", parse16(transaction["txid"]))
        |> Map.delete("txid")
      end)

    %{block | "hash" => parse16(hash), "tx" => tx}
  end

  defp parse_transaction(transaction) do
    hash = transaction["blockhash"]

    if is_nil(hash) do
      transaction
    else
      transaction
      |> Map.put("blockhash", parse16(hash))
      |> Map.put("hash", parse16(transaction["txid"]))
      |> Map.delete("txid")
    end
  end

  @doc """
   Get the current block by height through seed 'index'
  """
  def get_block_by_height(height), do: get_block_by_height(NodeChecker.get_random_node(), height)

  def get_block_by_height(url, height) do
    {:ok, response} = request(url, "getblock", [height, 1])
    {:ok, parse_block(response)}
  end

  def get_block_by_hash(hash), do: get_block_by_hash(NodeChecker.get_random_node(), hash)

  def get_block_by_hash(url, hash) do
    {:ok, response} = request(url, "getblock", [hash, 1])
    {:ok, parse_block(response)}
  end

  def get_current_height, do: get_current_height(NodeChecker.get_random_node())

  def get_current_height(url), do: request(url, "getblockcount", [])

  def get_transaction(txid), do: get_transaction(NodeChecker.get_random_node(), txid)

  def get_transaction(url, txid) do
    {:ok, response} = request(url, "getrawtransaction", [txid, 1])
    {:ok, parse_transaction(response)}
  end

  def get_asset(txid), do: get_asset(NodeChecker.get_random_node(), txid)

  def get_asset(url, txid), do: request(url, "getassetstate", [txid, 1])

  def get_contract(hash), do: get_contract(NodeChecker.get_random_node(), hash)

  def get_contract(url, hash), do: request(url, "getcontractstate", [hash])
end