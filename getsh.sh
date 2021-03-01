#!/bin/sh
lkasd

# --------
#   Vars

URL=$1
METHOD=$2

TMP_DIR="$HOME/.cache/getsh"
mkdir -p "$TMP_DIR"

JSON_STRING="$TMP_DIR/getsh_json_string.json"
RESPONSE="$TMP_DIR/getsh_response.json"
PROTOCOLS="$TMP_DIT/http_codes"
RESPONSE_META=""


# -------------
#   Functions

function show_help {
	echo

	printf "\033[36;1m"
	printf "  GetSh"
	printf "\033[0m\n"

	printf "\033[90m"
	printf "  Test your REST APIs from command line"
	printf "\033[0m"

	echo
	echo
	
	echo -e "\033[1m  GET:\033[0m"
	echo "    getsh <url>"
	echo

	echo -e "\033[1m  DELETE:\033[0m"
	echo "    getsh <url> DELETE"
	echo

	echo -e "\033[1m  POST:\033[0m"
	echo "    getsh <url> POST"
	echo

	echo -e "\033[1m  PUT:\033[0m"
	echo "    getsh <url> PUT"
	echo

	echo -e "\033[1m  PATCH:\033[0m"
	echo "    getsh <url> PATCH"
	echo

	exit 1
}


# ----------
#   No URL

case "$URL" in
	"-h" | "--help" | "")
		show_help
		;;
	"-d")
		cat $RESPONSE
		exit 1
		;;
	*)
		;;
esac

# ----------------------
#   No HTTP Codes File



# --------
#   Main

# reset
echo "" > $RESPONSE

# Default METHOD: GET
[ -z "$METHOD" ] && METHOD="GET"

echo -e "\n\033[1;36m$METHOD\033[0;36m on \033[3m$URL\033[0m"


case "$METHOD" in
	"GET" | "DELETE")
		RESPONSE_META=$( 
			curl -sS \
				--request $METHOD \
				$URL \
				-o $RESPONSE \
				-w "%{http_code}#%{content_type}#%{remote_ip}:%{remote_port}#%{scheme}#%{time_total}"
		)
		;;
	"POST" | "PUT" | "PATCH")
		# Use $EDITOR to build the string
		$EDITOR $JSON_STRING

		RESPONSE_META=$(
			curl -sS \
				-o $RESPONSE \
				--header "Content-Type: application/json" \
				--request $METHOD \
				--data "@$JSON_STRING" \
				$URL \
				-w "%{http_code}#%{content_type}#%{remote_ip}:%{remote_port}#%{scheme}#%{time_total}"
		)
		;;
	*)
		;;
esac


# --------------
#   Print Info

echo 

[ -z "$RESPONSE" ] || cat $RESPONSE | jq --color-output

printf "\n\n"

HTTP_CODE=$( echo "$RESPONSE_META" | awk 'BEGIN {FS = "#"}; {print $1}' )
HTTP_PROTOCOL=$( grep "$HTTP_CODE" /home/uyohn/Devel/getsh/http_status_codes )

[ -z "$RESPONSE_META" ] || echo "$RESPONSE_META" | awk -v protocol="$HTTP_PROTOCOL" 'BEGIN {FS = "#"} ;
	{print "\033[94m""Server Response Code:" "\033[0m\t\033[36m"   protocol "\033[0m"};
	{print "\033[94m""Conent Type:"          "\033[0m\t\t\033[36m" $2 "\033[0m"}
	{print "\033[94m""Remote IP:"            "\033[0m\t\t\033[36m" $3 "\033[0m"}
	{print "\033[94m""Scheme:"               "\033[0m\t\t\t\033[36m" $4 "\033[0m"}
	{print "\033[94m""Total Time:"           "\033[0m\t\t\033[36m" $5 "\033[0m"}
'
