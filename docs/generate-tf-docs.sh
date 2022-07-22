#! /bin/zsh

# Create array with all directories containing a main.tf file
dir=($(find .. -type f -name 'main.tf' | sed -r 's|/[^/]+$||' |sort |uniq))

# Run terraform docs in each of the directories
for i in "${dir[@]}"; do
    terraform-docs markdown table --output-file README.md --output-mode inject $i
done