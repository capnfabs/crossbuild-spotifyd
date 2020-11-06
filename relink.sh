# Find all absolute symlinks recursively in the current directory
# (find command) and process them line by line (`while read`)
find . -lname '/*' | while read -r link; do
  # Get the (broken) path from the symlink.
  abs_target=$(readlink "$link")
  # Prepend that with the current working directory and overwrite
  # the old link with the prepended version.
  ln -fs "$(pwd)$abs_target" "$link"
done
