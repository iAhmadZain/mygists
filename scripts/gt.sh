#!/bin/bash

# Check if namespace argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <namespace>"
    exit 1
fi

# Set the namespace from the first argument
NAMESPACE=$1

# Prompt for the Teleport cluster name
read -p "Enter your Teleport cluster name: " TELEPORT_CLUSTER

# Teleport Login
echo "Logging into Teleport..."
tsh kube login $TELEPORT_CLUSTER

# Check if tsh login was successful
if [ $? -ne 0 ]; then
    echo "Teleport login failed. Please check your credentials."
    exit 1
fi

# Get a list of pods in the namespace
echo "Fetching pods in namespace: $NAMESPACE"
PODS=$(kubectl get pods -n "$NAMESPACE" -o jsonpath='{.items[*].metadata.name}')

# Check if there are any pods
if [ -z "$PODS" ]; then
    echo "No pods found in the namespace: $NAMESPACE"
    exit 1
fi

# Display the pods and ask the user to choose one
echo "Please select a pod to connect to:"
select POD in $PODS; do
    if [ -n "$POD" ]; then
        echo "You have selected the pod: $POD"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Execute a shell inside the selected pod
echo "Connecting to pod $POD in namespace $NAMESPACE..."
kubectl exec -it "$POD" -n "$NAMESPACE" -- /bin/bash
