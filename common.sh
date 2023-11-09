

set -e

COMMON_OPTS="b:d:e:f:i:n:o:r:s:t:x:"
SCRIPT=$(basename "${0%.*}")

export BLOCK_SIZE=512
export DIRECT=1
export IOENGINE=libaio
export OUTDIR=.
export FILENAME=/dev/nvme0n1
export IO_DEPTH=1
export NUM_JOBS=1
export RW_MIX_READ=100
export SIZE=100%
export RUNTIME=180
export FIOEXE=fio

function parse_common_opt {
	case "$1" in
		b)  export BLOCK_SIZE=$2 ;;
		d)  export DIRECT=$2 ;;
		e)  export IOENGINE=$2 ;;
		f)  export FILENAME=$2 ;;
		i)  export IO_DEPTH=$2 ;;
		n)  export NUM_JOBS=$2 ;;
		o)  export OUTDIR=$2 ;;
		r)  export RW_MIX_READ=$2 ;;
		s)  export SIZE=$2 ;;
		t)  export RUNTIME=$2 ;;
		x)  export FIOEXE=$2 ;;
		\?)
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument." >&2
			exit 1
			;;

		*)  return 1 ;;
	esac

	return 0
}

function check_filenames {
    IFS=":"
    for entry in ${FILENAME}; do
	check_filename $entry
    done
    IFS=" "
}

function check_filename {
	if [ ! -e "$1" ]; then
		echo "$SCRIPT: You must specify an existing file or block IO device (${1})"
		exit 1
	fi

	if [ ! -b "$1" ]; then
		if [ ! -f "$1" ]; then
			echo "$SCRIPT: Only block devices or regular files are permitted"
			exit 1
		fi

		if [ ! -r "$1" ] && [ ! -w "$1" ]; then
			echo "$SCRIPT: Do not have read and write access to the target file"
			exit 1
		fi
	fi
}

function run {
	cd $OUTDIR

	check_filenames

	${DIR}/tools/cpuperf.py -C fio -s -m > ${SCRIPT}.cpu.log &
	CPUPERF_PID=$! ; trap 'kill -9 $CPUPERF_PID' EXIT

	${FIOEXE} ${DIR}/fio-scripts/$SCRIPT.fio ${FIOOPTS} --output=${SCRIPT}.log \
		  --output-format=normal

	cd - > /dev/null
}

function post {
	cd $OUTDIR

	${DIR}/pp-scripts/pprocess.py "$@" -m $SCRIPT -c $SCRIPT.log

	cd - > /dev/null
}
