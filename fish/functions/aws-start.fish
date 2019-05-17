function aws-start
    aws ec2 start-instances --instance-ids (aws-instance-id)
end
