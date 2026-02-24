update:
    cd mosacloud && git submodule foreach git pull origin main

create-cluster:
    kind create cluster

remove-cluster:
    kind delete cluster