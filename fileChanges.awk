BEGIN {
  added=0;
  modified=0;
  deleted=0;
}
{
    if ($1 == "A") {
      added++
    } else if ($1 == "M") {
      modified++
    } else if ($1 == "D") {
      deleted++
    }
}
END {
  print added, modified, deleted
}
