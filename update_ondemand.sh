#!/bin/bash
registry="kamalaweenat"
image="nodejs_test"
deploy_name="nodejs-test"


while true
do

# get the running pod in deployment
pod_name=$(kubectl get pods -n default | grep "$deploy_name" | grep Running | awk '{print $1}' )

if [ -z "$pod_name" ]; then
   echo "there is no pod name is runing.."
   sleep 60
   continue
fi

# get curretn running image tag in k8s
cur_image_tag=$(kubectl get pod --namespace=default "$pod_name"  -o json | jq '.status.containerStatuses[] | { "image": .image }' | grep image | cut -d ':' -f 3 | tr -d '"')

# get latest image tag from docker hub
latest_tag=$(curl https://registry.hub.docker.com/v2/repositories/"$registry"/"$image"/tags/ |jq '."results"[]["name"]' | head -n 1 | tr -d '"')

if [ $? ne 0 ]; then
   echo "an error occured when do curl to docker hub, retry again in 60 seconds.."
   sleep 60
   continue
fi

echo
echo "current pod name: $pod_name"
echo "current running image tag: $cur_image_tag"
echo "latest image tag on dockerhub: $latest_tag"

if [ "$cur_image_tag" == "$latest_tag" ];then
    echo "image: is already up-to-date"
else
    echo "image: is updating..."  
    
    kubectl set image deployment "$deploy_name" "$deploy_name"="$registry/$image":"$latest_tag"      
    #kubectl rollout restart deploy "$deploy_name"
    kubectl rollout status deploy "$deploy_name"
fi

sleep 60 # 

done



