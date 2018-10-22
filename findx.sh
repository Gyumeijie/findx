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

# Prevent pathname expansion and avoid `paths must precede expression`
data=$(sed "s:-name[ ]*\([^ \)]*\):-name \'\1\':g" <<<"$@")
# Remove \; to ;
data=$(sed "s:\\\\;:;:" <<< "$data")

re='-exec[^;]*;'
if [[ $data =~ $re ]];
then
  tempfile="/tmp/tempfile$$.sh"
  touch $tempfile && chmod u+x $tempfile

  # Extract -exec comannd and save all them to the tempfile
  echo "#! /bin/bash" >> $tempfile
  echo 'readonly file=$1 && shift' >> $tempfile
  # Multi -exec commands sparated by '\n'
  exec=$(sed "s:[^;]*-exec \([^;]*\);:\1\\\n:g" <<< "$data")
  echo -e $(sparateExecCommad "$exec") >> $tempfile

  # Reconstruct command: remove -exec commands and append a new one
  cmd=$(sed "s:\(-exec [^;]*;\): :g" <<< "$data")
  cmd=" ${cmd} -exec $tempfile {} \;"
  
  # Finally execute the find command
  eval find $cmd
else
  eval find $data
fi

rm -f $tempfile
