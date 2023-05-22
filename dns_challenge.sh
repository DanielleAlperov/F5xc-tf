#!/bin/bash

# Define API endpoint, API key and additional record

ZONE=$(echo $CERTBOT_DOMAIN | sed 's/^[^.]*\.//')
API_ENDPOINT="https://${1}.console.ves.volterra.io/api/config/dns/namespaces/system/dns_zones/${ZONE}"
API_KEY=$2

HOSTNAME=$(echo $CERTBOT_DOMAIN | cut -d. -f1)
NEW_RECORD="{\"ttl\":3600,\"txt_record\":{\"name\":\"_acme-challenge.${HOSTNAME}\",\"values\":[\"${CERTBOT_VALIDATION}\"]}}"

call_api() {
  local endpoint=$1
  local method=$2
  local data=$3
  local retry_count=0
  local max_retries=3
  local wait_time=5  # wait time before retry in seconds

  while ((retry_count < max_retries)); do    
    response=$(curl -s -w "\n%{http_code}" -H "Authorization: APIToken $API_KEY" -H "Content-Type: application/json" -X $method -d "$data" "$endpoint")
    status_code=$(echo "$response" | tail -n1)
    response_body=$(echo "$response" | jq -r '.response_body')
    
    if [ "$status_code" -ge 200 ] && [ "$status_code" -lt 300 ]; then      
      echo "{\"status\": $status_code, \"response_body\": $response_body}"
      return 0
    else
      echo "API call failed with response code $status_code. Retrying..."
      retry_count=$((retry_count + 1))
      sleep $wait_time
    fi
  done

  echo "API call failed after $max_retries attempts."
  exit 1
}



if [ "$CERTBOT_AUTH_OUTPUT" ]; then
    echo "Starting to remove the record"
    response=$(call_api $API_ENDPOINT GET)
    status_code=$(echo "$response" | jq -r '.status')
    list_data=$(echo "$response" | jq -r '.response_body')
    
    # Remove new record from the list    
    list_data=$(echo $list_data | jq "del(.spec.primary.default_rr_set_group[] | select(. == $NEW_RECORD))")
    
    # PUT API call to push the updated list
    response=$(call_api $API_ENDPOINT PUT "$list_data")    
    echo "Record removed"

else
    echo "Starting to add the record"
    # GET API call to retrieve the list
    
    response=$(call_api $API_ENDPOINT GET)
    
    status_code=$(echo "$response" | jq -r '.status')
    list_data=$(echo "$response" | jq -r '.response_body')    

    # Add new record to the list
    list_data=$(echo $list_data | jq ".spec.primary.default_rr_set_group += [$NEW_RECORD]")
    
    
    # PUT API call to push the new list
    
    response=$(call_api $API_ENDPOINT PUT "$list_data")
    echo "Record Added"
    
fi

