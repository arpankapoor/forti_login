#!/bin/bash

# Enable curl alias
alias curl="curl --insecure --silent --max-time 30"
shopt -s expand_aliases

USERNAME=""
PASSWORD=""
KEEPALIVE_URL=""

cmd_available() {
	command -v $1 &> /dev/null
}

# Print arguments to stderr and exit
fail() {
	printf "$*\n" 1>&2
	exit 1
}

get_effective_url() {
	curl --location --output /dev/null --write-out "%{url_effective}" $1
}

# Remove $2 from front and $3 from back of the string $1
remove_substr() {
	local tmp=${1##$2}
	echo ${tmp%%$3}
}

# Get username and password from parameters/stdin
get_credentials() {
	if [[ $# -eq 0 ]]
	then
		read -r -p "Username: " USERNAME
		read -rst 30 -p "Password: " PASSWORD && echo ""
	elif [[ $# -eq 1 ]]
	then
		USERNAME=$1
		read -rst 30 -p "Password: " PASSWORD && echo ""
	else
		USERNAME=$1
		PASSWORD=$2
	fi
}

# Display a countdown for $1 seconds with $2 prefixed and $3 suffixed
display_countdown() {
	local secs=$1
	while [[ $secs -gt 0 ]]
	do
		echo -ne "\033[0K\r$2 $secs $3"
		sleep 1
		: $((--secs))
	done
}

do_logout() {
	local logout_url=${KEEPALIVE_URL/keepalive/logout}
	if ! curl --output /dev/null "$logout_url"
	then
		fail "Error logging out."
	else
		echo "" && echo "Logged out."
	fi
}

keepalive() {
	while true
	do
		local html=$(curl --output - "$KEEPALIVE_URL")
		if [[ $? -ne 0 ]]
		then
			fail "Error in authentication refresh."
		fi

		local countdown=$(remove_substr "$html" \
						"*var countDownTime=" \
						" + 1;*")
		countdown=$((countdown - 60))

		# Display a countdown if stdout is a terminal
		if [[ -t 1 ]]
		then
			display_countdown "$countdown" \
				"Authentication refresh in" \
				"seconds."
		else
			sleep "$countdown" & wait
		fi
	done
}

main() {
	# Do we have curl?
	cmd_available "curl" || fail "Please install curl."

	local google="www.google.com"
	local effective_url=$(get_effective_url "$google")

	# Did we get redirected to the authentication page?
	echo "$effective_url" | grep -q "fgtauth" || \
		fail "Did NOT get redirected to authentication page."

	# Get login credentials
	get_credentials "$@" || fail "\nFailed to get login credentials."

	# Extract base URL and magic parameter
	local base_url=$(remove_substr "$effective_url" "" "fgtauth*")
	local magic=$(remove_substr "$effective_url" "*fgtauth\?" "" )

	# POST form data to base_url
	local html=$(curl --output - \
			--data-urlencode 4Tredir="$google" \
			--data-urlencode magic="$magic" \
			--data-urlencode username="$USERNAME" \
			--data-urlencode password="$PASSWORD" \
			"$base_url")

	# Failed?
	echo "$html" | grep -qi "failed" && fail "Authentication failed."

	echo "Logged in."
	if [[ -t 1 ]]
	then
		echo "Press Ctrl-C to logout."
	fi

	KEEPALIVE_URL=$(remove_substr "$html" "*location.href=\"" "\";*")

	# Logout on interruption
	trap "do_logout; exit 0" SIGINT SIGTERM

	keepalive
}

main "$@"
