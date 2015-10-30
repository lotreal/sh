#!/bin/bash
mxmlc -debug=true -library-path+=/home/lot/sf/ActionScript/alcon/as3/alcon.swc -sp+=/home/lot/workspace/flflash/lib/ -static-link-runtime-shared-libraries=true $1
# -o /home/lot/workspace/flflash/bin/flf.swf