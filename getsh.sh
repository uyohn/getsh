#!/bin/sh

# --------
#   Vars

URL=$1
METHOD=$2

JSON_STRING="/home/uyohn/.scripts/.getsh_json_string.json"
RESPONSE="/home/uyohn/.scripts/.getsh_response.json"
SERVER_CODE=""


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


# --------
#   Main

# reset
echo "" > $RESPONSE

# Default METHOD: GET
[ -z "$METHOD" ] && METHOD="GET"

echo -e "\n\033[1;36m$METHOD\033[0;36m on \033[3m$URL\033[0m"


case "$METHOD" in
	"GET" | "DELETE")
		SERVER_CODE=$( 
			curl -sS \
				--request $METHOD \
				$URL \
				-o $RESPONSE \
				-w "\033[94mServer Response Code:\033[0m\t\033[36m%{http_code}\033[0m\n\
\033[94mContent Type:\033[0m\t\t\033[36m%{content_type}\033[0m\n\
\033[94mRemote Ip:\033[0m\t\t\033[36m%{remote_ip}:%{remote_port}\033[0m\n\
\033[94mScheme:\033[0m\t\t\t\033[36m%{scheme}\033[0m\n\
\033[94mTotal Time:\033[0m\t\t\033[36m%{time_total}s\033[0m"
		)
		;;
	"POST" | "PUT" | "PATCH")
		# Use $EDITOR to build the string
		$EDITOR $JSON_STRING

		SERVER_CODE=$(
			curl -sS \
				-o $RESPONSE \
				--header "Content-Type: application/json" \
				--request $METHOD \
				--data "@$JSON_STRING" \
				$URL \
				-w "\033[94mServer Response Code:\033[0m\t\033[36m%{http_code}\033[0m\n\
\033[94mContent Type:\033[0m\t\t\033[36m%{content_type}\033[0m\n\
\033[94mRemote Ip:\033[0m\t\t\033[36m%{remote_ip}:%{remote_port}\033[0m\n\
\033[94mScheme:\033[0m\t\t\t\033[36m%{scheme}\033[0m\n\
\033[94mTotal Time:\033[0m\t\t\033[36m%{time_total}s\033[0m"
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

[ -z "$SERVER_CODE" ] || echo -e "$SERVER_CODE"
