#!/bin/sh
lli=${LLVMINTERP-lli}
exec $lli \
    /scratch/qijing.huang/firechip/hls_adpcm_encode/src/main/c/adpcm_prj/solution1/.autopilot/db/a.g.bc ${1+"$@"}
