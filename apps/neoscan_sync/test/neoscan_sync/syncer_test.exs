defmodule NeoscanSync.SyncerTest do
  use NeoscanSync.DataCase

  alias NeoscanSync.Syncer

  test "import_block/1" do
    assert {:ok, _} = Syncer.import_block(0)
  end
end