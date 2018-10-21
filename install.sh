
#!/bin/bash

shell=${SHELL##*/}
cp ./findx.sh ~/.findx.sh

rc=$(eval echo ~/.${shell}rc)
echo "" >> $rc
echo 'alias findx="~/.findx.sh"' >> $rc