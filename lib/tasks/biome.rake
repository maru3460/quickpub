# frozen_string_literal: true

# Biome用のRakeタスク
# フロントエンドコードのlintとformatを実行する
namespace :biome do
  # bin/rails biome:format
  desc "Format code with Biome"
  task format: [ "react_router:npm_install" ] do
    puts "Formatting code with Biome..."
    Dir.chdir("#{Dir.pwd}/frontend") do
      system("npm", "run", "format")
    end
  end

  # bin/rails biome:lint
  desc "Lint code with Biome"
  task lint: [ "react_router:npm_install" ] do
    puts "Linting code with Biome..."
    Dir.chdir("#{Dir.pwd}/frontend") do
      system("npm", "run", "lint")
    end
  end
end
