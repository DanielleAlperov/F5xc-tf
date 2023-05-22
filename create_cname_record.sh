
# Define API endpoint, API key and additional record
API_ENDPOINT_DNS="$4/config/namespaces/default/http_loadbalancers/$3/get-dns-info"
API_ENDPOINT="$4/config/dns/namespaces/system/dns_zones/$2"
API_KEY="$5"

retry_count=0
max_retries=3
wait_time=5  # wait time before retry in seconds


echo $1 $2 $3 $4

get_cname() {
  local retry_count=0
  local max_retries=3
  local wait_time=5  # wait time before retry in seconds


  while ((retry_count < max_retries)); do
     response=$(curl -s -w "\n%{http_code}" -H "Authorization: APIToken $API_KEY" -H "Content-Type: application/json" -X GET "$API_ENDPOINT_DNS")
    status_code=$(echo "$response" | tail -n1)
    response_body=$(echo "$response" | sed '$d')

    if [ "$status_code" -ge 200 ] && [ "$status_code" -lt 300 ]; then
      host_name=$(echo "$response_body" | jq -r '.dns_info.host_name')
      echo "$host_name"
      return
    else
      echo "API call failed with response code $status_code. Retrying..."
      retry_count=$((retry_count + 1))
      sleep $wait_time
    fi
  done

  if ((retry_count == max_retries)); then
    echo "API call failed after $max_retries attempts and status code $status_code."
    exit 1
  fi
}
cname_value=$(get_cname)
echo "Host Name: $cname_value"
NEW_RECORD="{\"ttl\":3600,\"cname_record\":{\"name\":\"$1\",\"value\":\"$cname_value\"}}"


  while ((retry_count < max_retries)); do    
    response=$(curl -s -w "\n%{http_code}" -H "Authorization: APIToken $API_KEY" -H "Content-Type: application/json" -X GET $API_ENDPOINT)
    status_code=$(echo "$response" | tail -n1)
    response_body=$(echo "$response" | awk 'NR>1 {print prev} {prev=$0}')

   if [ "$status_code" -ge 200 ] && [ "$status_code" -lt 300 ]; then      
      #echo "{\"status\": $status_code, \"response_body\": $response_body}"
      break
    else
      echo "API call failed with response code $status_code. Retrying..."
      retry_count=$((retry_count + 1))
      sleep $wait_time
    fi
  done

#echo $response

#list_data=$(echo "$response" | jq -r '.response_body') 
list_data=$(echo "$response_body" | jq ".spec.primary.default_rr_set_group += [$NEW_RECORD]")

echo "Adding Address"
response=$(curl -s -w "\n%{http_code}" -H "Authorization: APIToken $API_KEY" -H "Content-Type: application/json" -X PUT -d "$list_data" $API_ENDPOINT)
status_code=$(echo "$response" | tail -n1)
response_body=$(echo "$response" | awk 'NR>1 {print prev} {prev=$0}')

echo $status_code $response_body


