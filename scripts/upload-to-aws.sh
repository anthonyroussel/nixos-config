#!/usr/bin/env nix-shell
#!nix-shell -i bash -p awscli2
set -e

export AWS_REGION=eu-west-3
export AWS_PROFILE=rsl-cloud-poweruser

PROJECT=rsl-cloud
S3_BUCKET_NAME=ami.rsl-cloud.aws.aroussel.cloud
F=nixos-amazon-image-23.05.20230927.5cfafa1-x86_64-linux.vhd

nix build .#$PROJECT
aws s3 cp result/$F s3://$S3_BUCKET_NAME

task_id=$(aws ec2 import-snapshot \
  --disk-container "Format=VHD,UserBucket={S3Bucket=$S3_BUCKET_NAME,S3Key=$F}" \
  --role-name rsl-vmimport \
  --query 'ImportTaskId' \
  --output text)

echo "Waiting for task $task_id"

aws ec2 wait snapshot-imported --import-task-ids "$task_id"

snapshot_id=$(aws ec2 describe-import-snapshot-tasks \
  --import-task-ids "$task_id" \
  --query 'ImportSnapshotTasks[0].SnapshotTaskDetail.SnapshotId' \
  --output text)

echo "Snapshot: $snapshot_id"

image_id=$(aws ec2 register-image \
  --name $PROJECT \
  --description "$PROJECT NixOS image" \
  --block-device-mappings DeviceName="/dev/xvda",Ebs={SnapshotId=$snapshot_id} \
  --root-device-name "/dev/xvda" \
  --architecture x86_64 \
  --virtualization-type hvm \
  --boot-mode uefi \
  --ena-support \
  --query 'ImageId' \
  --output text)

echo "AMI: $image_id"

aws s3 rm s3://$S3_BUCKET_NAME/$F
