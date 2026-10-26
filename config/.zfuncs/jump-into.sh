local host_arg=$1

if [[ -z $host_arg ]]; then
	echo "Error: Missing Host Argument"
	return 1
fi

local final_host
if [[ "$host_arg" =~ '([0-9]+).([0-9]+).([0-9]+).([0-9]+)' ]]; then
	final_host="$host_arg"
else
	final_host="$host_arg.internal.faceftw.dev"
fi


ssh "face@$final_host"
