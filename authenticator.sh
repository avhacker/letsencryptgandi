#!/bin/sh

#certbot certonly --manual --preferred-challenges=dns --manual-auth-hook /path/to/dns/authenticator.sh -d host.example.com

APIKEY=$GANDI_API_KEY

okdomain="0"
rdn=$CERTBOT_DOMAIN
index="i"
subdomain=""

while [ $okdomain == "0" ] 
do
	echo "Try to check your domain name:$rdn"
	response=$(curl -s -H "X-Api-Key: $APIKEY" https://dns.api.gandi.net/api/v5/domains/$rdn )
	x=$(echo $response | grep "fqdn" -)
	if [ $? == "0" ]; then
		okdomain="1";
		break;
	fi

	sub=$(echo $rdn | cut -d'.' -f1 -)
	subdomain="${subdomain}.${sub}"
	rdn=$(echo "$rdn" | sed -E 's/^[^\.]+\.//' )

	index="${index}i"
	if [ "$index" == "iiiiiiiiii" ]; then		# Only try 10 times for getting domain name
		break;
	fi
done

if [ "$okdomain" == "0" ]; then
	echo "I can't get your domain name, please confirm domain name or make sure you use Gandi LiveDNS"
	exit;
fi

subdomain=$(echo $subdomain | sed -E 's/^ *\.//')
subdomain="_acme-challenge.${subdomain}"
echo "CERTBOT_DOMAIN is: $CERTBOT_DOMAIN"
echo "Your domain name is: $rdn"
echo "SubDomain is: $subdomain"
echo "CERTBOT_VALIDATION is: $CERTBOT_VALIDATION"

URL="https://dns.api.gandi.net/api/v5/domains/$rdn/records/$subdomain/TXT"
echo "RESTful URL:$URL"

result=$(curl -s -X PUT "$URL" -H "X-Api-Key: $APIKEY" -H "Content-Type: application/json" --data "{\"rrset_type\":\"TXT\", \"rrset_name\": \"_acme-challenge.${subdomain}\", \"rrset_values\": [\"$CERTBOT_VALIDATION\"], \"rrset_ttl\":\"300\"}" )
echo "RESULT: $result"

sleep 30
