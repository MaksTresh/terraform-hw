import boto3


region = 'us-east-1'

ec2 = boto3.resource('ec2')
volume_ids = [volume.id for volume in ec2.volumes.all()]

ec2client = boto3.client('ec2',region_name=region)

def lambda_handler(event, context):
    for volume_id in volume_ids:
        volume = ec2client.volume(volume_id)
        instance = ec2client.instance(volume.attachments[0]["InstanceId"])
        volume.create_tags(Tags = instance.tags)
    return {"status": "ok"}
