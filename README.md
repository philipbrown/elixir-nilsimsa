# Nilsimsa

[Documentation](https://hexdocs.pm/nilsimsa/)

```elixir
 def deps do
   [
     {:nilsimsa, "~> 1.0.0"}
   ]
 end
 ```

<!-- MDOC !-->

Nilsimsa is an implementation of a locality-sensitive hashing algorithm where similar input values produce similar hashes. The more similar the input strings are, the smaller the bitwise different between the out generated hashes.

Nilsimsa hashes are useful for detecting texts of the same origin.

## Processing a string

To process a string, pass the value to the `process/1` function:
```elixir
Nilsimsa.process("abcdefgh")
```

You can also process a stream:
```elixir
"war_and_peace.txt"
|> File.stream!()
|> Enum.reduce(Nilsimsa.new(), &Nilsimsa.process/2)
```

## Generating a digest

To generate a digest of the Nilsimsa hash, just pass the process struct to the `to_string/1` function:

```elixir
to_string(Nilsimsa.process("abcdefgh"))
# => 14c8118000000000030800000004042004189020001308014088003280000078
```

## Comparing values

To compare two values, use the `compare/2` function:

```elixir
Nilsimsa.compare(Nilsimsa.process("hello world"), Nilsimsa.process("all of your base"))
# => 3
```
<!-- MDOC !-->
