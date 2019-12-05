resource "aws_sns_topic" "main" {
  name  = var.sns_topic_name
}

# # SnsSubscription:
#     Type: "AWS::SNS::Subscription"
#     Properties:
#       Endpoint: !Ref EmailAddress
#       Protocol: "email"
#       TopicArn: !Ref SnsTopic