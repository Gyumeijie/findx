#! /bin/bash

# Sparate comma-sparated exec commands, e.g. -exec 'cmd1, cmd2, cmd3;'
function sparateExecCommad() {
  local string=$1
  local len=${#string}
  local range=`eval echo {0..$((len-1))}`
  local quote='CLOSE'
  local ret=''

  for i in $range;
  do
    char=${string:i:1}
   
    if [[ "$char" = "\"" ]]; then
       if [[ $quote = "CLOSE" ]]; then quote="OPEN"; else quote="CLOSE"; fi
    fi

    if [[ "$char" = "," ]] && [[ $quote = "CLOSE" ]]; then
        # Replace all unquoted commas with '\n'
        ret=${ret}'\n'
        continue
    fi

    ret=${ret}$char
  done

  # Prevent expansion and quotes removal
  echo "$ret"
}


re='-exec[^;]*;'
if [[ $@ =~ $re ]];
then
  tempfile="/tmp/tempfile$$.sh"
  touch $tempfile && chmod u+x $tempfile

  # Extract -exec comannd and save all them to the tempfile
  echo "#! /bin/bash" >> $tempfile
  # Multi -exec commands sparated by '\n'
  exec=$(sed "s:[^;]*-exec \([^;]*\);:\1\\\n:g" <<< "$@")
  echo -e $(sparateExecCommad "$exec") >> $tempfile

  # Reconstruct command: remove -exec commands and append a new one
  cmd=$(sed "s:\(-exec [^;]*;\): :g" <<< "$@")
  cmd=" ${cmd} -exec $tempfile {} ;"

  # Finally execute the find command
  find $cmd
else
  find $@
fi

rm -f $tempfile
