#!/bin/bash

# cat ./200_221222.txt | tr -d '\r' | head -n 2100 |
# paste - - - - - - - - - - - - - - - | awk '

# 256 * 34 = 8704
cat $1 | tr -d '\r' | awk '
  BEGIN{
  FS="\t"; OFS="\t"
}{
  if ($0 ~ /^([^ ]+#)?traceroute /) {
    printf("\n%s", $0)
  } else {
    printf("\t%s", $0)
  }
}' | awk '
BEGIN{
  FS="\t"; OFS="\t"
}{
  sub(/^.*traceroute /,"",$1)
  sub(/ .*$/,"",$1)
  for(k = 5; k <= NF; k++) {
    $(k) = gensub(/^ *[0-9]+ +([^ ]+).*$/, "\\1", 1, $(k))
  }
  $0=$0
  print
}
' | cut -f 1,5-
