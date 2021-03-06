defmodule Neoscan.Vouts.VoutTest do
  use Neoscan.DataCase

  alias Neoscan.Vouts.Vout

  describe "schema" do
    test "empty schema has default txid is nil" do
      vout = %Vout{}
      assert is_nil(vout.txid)
    end
  end

  describe "changeset/2" do
    test "returns valid changeset" do
      vout = %{id: 12, txid: "1234", time: 1234, block_height: 124}

      attrs = %{
        "address" => {%{address: "address", id: 1234}, nil},
        "value" => "23",
        "n" => 1,
        "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"
      }

      changeset = Vout.changeset(vout, attrs)

      assert changeset.valid?
    end
  end

  test "update_changeset/2" do
    vout = %{id: 12, txid: "1234", time: 1234, block_height: 124}

    attrs = %{
      "address" => {%{address: "address", id: 1234}, nil},
      "value" => "23.4",
      "n" => 1,
      "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"
    }

    changeset = Vout.changeset(vout, attrs)
    assert 2133 == Vout.update_changeset(changeset, %{:end_height => 2133}).changes.end_height
    assert Vout.update_changeset(changeset, %{:claimed => true}).changes.claimed
  end
end
