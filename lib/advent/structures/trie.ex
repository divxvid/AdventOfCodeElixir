defmodule Advent.Structures.Trie do
  alias Advent.Structures.Trie
  defstruct [:root]

  defmodule Node do
    defstruct depth: 0, final?: false, children: Map.new()
  end

  def new(), do: %Trie{root: %Node{}}

  def insert(%Trie{root: root} = t, value) do
    root = _insert(root, value)
    Map.put(t, :root, root)
  end

  def find(%Trie{root: root}, value) do
    _find(root, value)
    |> Enum.reverse()
  end

  defp _find(%Node{final?: final?} = current, <<>>) do
    if final? do
      [{:ok, current}]
    else
      [:error]
    end
  end

  defp _find(%Node{final?: final?} = current, <<ch, rest::binary>> = value) when final? do
    case Map.fetch(current.children, ch) do
      {:ok, child_node} -> [{:unfinished, value} | _find(child_node, rest)]
      :error -> [{:unfinished, value}]
    end
  end

  defp _find(%Node{} = current, <<ch, rest::binary>>) do
    case Map.fetch(current.children, ch) do
      {:ok, child_node} ->
        _find(child_node, rest)

      :error ->
        [:error]
    end
  end

  defp _insert(%Node{} = current, <<>>) do
    Map.put(current, :final?, true)
  end

  defp _insert(%Node{children: children} = current, <<ch, rest::binary>>) do
    child_node =
      case Map.fetch(children, ch) do
        {:ok, child_node} ->
          _insert(child_node, rest)

        :error ->
          node = %Node{depth: current.depth + 1, final?: false, children: Map.new()}
          _insert(node, rest)
      end

    children = Map.put(children, ch, child_node)
    Map.put(current, :children, children)
  end
end
