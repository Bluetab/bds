defmodule Bds.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/bluetab/bds"

  def project do
    [
      app: :bds,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      package: package(),
      description: "Bluetab Design System — CSS, interactions, and Phoenix components",
      docs: docs(),
      name: "Bds"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix, "~> 1.7", optional: true},
      {:gettext, "~> 1.0", optional: true}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "bds.sync_assets"],
      "assets.setup": ["cmd --cd assets npm install"],
      "assets.build": ["cmd --cd assets npm run build:lib", "bds.sync_assets"],
      "assets.dev": ["cmd --cd assets npm run dev"],
      "bds.sync_assets": &sync_assets/1
    ]
  end

  defp package do
    [
      maintainers: ["Bluetab"],
      licenses: ["UNLICENSED"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib priv mix.exs README.md .formatter.exs)
    ]
  end

  defp docs do
    [
      main: "Bds",
      extras: ["README.md"]
    ]
  end

  defp sync_assets(_) do
    import Mix.Generator

    dist = Path.join(__DIR__, "assets/dist")
    priv = Path.join(__DIR__, "priv/static")
    fonts_src = Path.join(__DIR__, "assets/src/fonts")
    fonts_dest = Path.join(priv, "fonts")

    for {src, dest} <- [
          {"bds.css", "bds.css"},
          {"interactions.js", "interactions.js"}
        ] do
      from = Path.join(dist, src)
      to = Path.join(priv, dest)

      if File.exists?(from) do
        create_directory(priv)
        File.cp!(from, to)
        Mix.shell().info([:green, "Synced ", :reset, "#{src} → priv/static/#{dest}"])
      else
        Mix.raise("""
        Missing #{from}. From the bds repo root run:

            mix assets.build
        """)
      end
    end

    if File.dir?(fonts_src) do
      create_directory(fonts_dest)

      for font <- File.ls!(fonts_src), String.ends_with?(font, [".woff2", ".woff", ".ttf"]) do
        File.cp!(Path.join(fonts_src, font), Path.join(fonts_dest, font))
        Mix.shell().info([:green, "Synced ", :reset, "fonts/#{font} → priv/static/fonts/#{font}"])
      end
    end
  end
end
