#!/bin/bash

REQ_URL=www.google.com

# Check if we can access Google
ping -qc 1 -W 2 $REQ_URL &> /dev/null
if [[ $? -eq 0 ]]
then
    echo 'You haz the internetz'
    exit 1
fi

# Get username & password
if [[ $# -eq 0 ]]
then
    read -p 'Username: ' USERNAME
    read -sp 'Password: ' PASSWORD
    echo
elif [[ $# -eq 1 ]]
then
    USERNAME=$1
    read -sp 'Password: ' PASSWORD
    echo
else
    USERNAME=$1
    PASSWORD=$2
fi

# Check if we have curl
command -v curl &> /dev/null
if [[ $? -ne 0 ]]
then
    echo 'Please install curl.'
    echo 'Quitting...'
    exit 1
fi

# Check if we get redirected
http_code=$(curl -kso /dev/null -w "%{http_code}" $REQ_URL)
if [[ $http_code -ne 303 ]]
then
    echo 'No redirect to Firewall AUTH'
    exit 1
fi

# The URL we get redirected to
auth_url=$(curl -Lkso /dev/null -w "%{url_effective}" $REQ_URL)

# Split the URL into two parts
array=(${auth_url//fgtauth?/ })
post_url=${array[0]}
magic=${array[1]}

html_file=$(mktemp -q)
curl -kso $html_file \
    --data-urlencode 4Tredir=$REQ_URL \
    --data-urlencode magic=$magic \
    --data-urlencode username=$USERNAME \
    --data-urlencode password=$PASSWORD \
    $post_url

# Do we have the logout button?
lgout=$(grep logout $html_file)
if [[ -z $lgout ]]
then
    echo 'Authentication failed.'
    rm -f $html_file
    exit 1
fi

echo 'Logged in.'
echo 'Press Ctrl-C to logout.'

# Extract the keepalive URL from the HTML file (hack)
ka_url=$(grep keepalive $html_file)
ka_url=${ka_url// /}                # Remove whitespace
ka_url=${ka_url//location.href=\"/}
ka_url=${ka_url%\";}

# Display the logout URL just in case
# logout_url=${ka_url//keepalive/logout}
# echo "Logout: $logout_url"

# Delete HTML file
rm -f $html_file

do_logout() {
    logout_url=${ka_url//keepalive/logout}
    http_code=$(curl -kso /dev/null -w "%{http_code}" $logout_url)
    if [[ $http_code -ne 200 ]]
    then
        echo 'Error logging out.'
    else
        echo
        echo 'Logged out.'
    fi
    exit 0
}

# Logout on interruption
trap do_logout SIGINT SIGTERM

# KEEP ALIVE !!
while true
do
    n=295
    sleep $n

    # Send GET to the keepalive URL
    http_code=$(curl -kso /dev/null -w "%{http_code}" $ka_url)
    if [[ $http_code -eq 200 ]]
    then
        echo -n '.'
    else
        echo 'Error sending keepalive signal.'
        do_logout
        exit 1
    fi
done
