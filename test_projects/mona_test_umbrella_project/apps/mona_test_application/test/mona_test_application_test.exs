defmodule MonaTestApplicationTest do
  use ExUnit.Case
  doctest MonaTestApplication

  test "greets the world" do
    assert MonaTestApplication.hello() == :world
  end
end
