
# Advent of code for elixir

> **work in progress**, but you can fork and use it as you like. I wanted something ready for me to use for the first day of AoC. I'll keep improving it as I go.

## Prepare the environment

Install deps
```sh
mix deps.get
```

Create the env file
```sh
touch .env
```

Add the session cookie in the .env file
```sh
echo "AOC_SESSION=your_session_cookie" > .env
```

## Run the tasks

Fetch the input, description and setup the solution

```sh
# mix run download YEAR DAY
mix setup 2024 1
```

Run the solution

```sh
# mix run solve YEAR DAY PART
mix solve 2024 1 1
```

Run and submit the solution

```sh
mix solve 2024 1 1 --submit # or -s
```

### Contributing

Yes, please
