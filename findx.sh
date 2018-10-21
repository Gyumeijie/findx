#! /bin/bash

re='-exec[^;]*;'

if [[ $@ =~ $re ]];
then
  tempfile="/tmp/tempfile$$.sh"
  touch $tempfile && chmod u+x $tempfile

  # Extract -exec comannd and save all them to the tempfile
  echo "#! /bin/bash" >> $tempfile
  echo -e $(sed "s:[^;]*-exec \([^;]*\);:\1\\\n:g" <<< "$@") >> $tempfile

  # Reconstruct command: remove -exec commands and append a new one
  cmd=$(sed "s:\(-exec [^;]*;\): :g" <<< "$@")
  cmd=" ${cmd} -exec $tempfile {} ;"

  # Finally execute the find command
  find $cmd
else
  find $@
fi

rm -f $tempfile
