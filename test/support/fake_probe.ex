defmodule FakeServerProbe do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(_state) do
    {:ok, false}
  end

  def probed?(pid) do
    GenServer.call(pid, :probed?)
  end

  def handle_cast(:probe, _state) do
    {:noreply, true}
  end

  def handle_call(:probed?, _from, state) do
    {:reply, state, state}
  end
end

defmodule FakeFunctionProbe do
  use TestAgent

  def call(pid) do
    fn ->
      if alive?() do
        update(pid, :probe_called, true)
      end
    end
  end

  def fail(pid) do
    fn ->
      if alive?() do
        update(pid, :probe_called, true)
        raise :nosup
      end
    end
  end
end
