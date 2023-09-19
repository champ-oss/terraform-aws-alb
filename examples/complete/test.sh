set -e

# Test public load balancer
for i in {1..12}; do
  echo -e "\nSending HTTP request to $URL"
  curl -s $URL | grep successful
  result=$?
  if [[ $result -eq 0 ]]
  then
    break
  else
    sleep 5
  fi
done

if [[ $result -ne 0 ]]
then
  exit 1
fi

# Validate that bucket contains ALB logs
aws s3 ls s3://$BUCKET | grep txt