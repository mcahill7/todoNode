#!/bin/bash
TASK_FAMILY="ecscompose-personal"
SERVICE_NAME="nodetodo-service"
NEW_DOCKER_IMAGE="mcahill7/todoapp:$BUILD_NUMBER"
CLUSTER_NAME="Staging-Mason2"
OLD_TASK_DEF=$(aws ecs describe-task-definition --task-definition $TASK_FAMILY --output json)
NEW_TASK_DEF=$(echo $OLD_TASK_DEF | jq --arg NDI $NEW_DOCKER_IMAGE '.taskDefinition.containerDefinitions[1].image=$NDI')
FINAL_TASK=$(echo $NEW_TASK_DEF | jq '.taskDefinition|{family: .family, volumes: .volumes, containerDefinitions: .containerDefinitions}')
aws ecs register-task-definition --family $TASK_FAMILY --cli-input-json "$(echo $FINAL_TASK)"
aws ecs update-service --service $SERVICE_NAME --task-definition $TASK_FAMILY --cluster $CLUSTER_NAME --desired-count 2
