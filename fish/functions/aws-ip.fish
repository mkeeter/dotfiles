function aws-ip
    aws ec2 describe-instances --instance-ids (aws-instance-id) | jq '.Reservations[0].Instances[0].PublicDnsName' | sed 's/\"//g'
end
