# MongoDB Locust Load Testing at scale

This project depends on [mongolocust](https://github.com/sabyadi/mongolocust) project created by Adilet.

## Setup

Create a _terraform.tfvars_ for both _aws_ and _atlas_ [terraform](terraform) subdirectories.
See the _variables.tf_ files to see what are the required inputs.

### Setup Atlas cluster

Run terraform to create the Atlas cluster:

```bash
cd terraform/atlas
terraform init
terraform apply
```

### Setup AWS EC2 instances

Run terraform to create the AWS ec2 instances:

```bash
cd terraform/aws
terraform init
terraform apply
```

---

## NOTE

Make sure you have exported your AWS public and private keys before you attempt to run terraform!

---

## Running Load Tests

Capture the MongoDB URI from the Atlas terraform output and replace it in the same files - remember to add the username/password.
Replace the ssh key file in those files as well.

Call the [run_locust.sh](run_locust.sh) to launch the test:

```bash
./run_locust.sh
```

## Stop Load Tests

Call the [kill_locust.sh](kill_locust.sh) to stop the test:

```bash
./kill_locust.sh
```
