# Cheat Sheet: Conquer Thoughts AWS, Terraform, and GitHub OIDC

## Terraform Roots

| Root | Owns | Lifecycle |
| --- | --- | --- |
| `account-bootstrap` | Account-level GitHub OIDC provider singleton | Create/import once per AWS account; protect from environment teardown |
| `bootstrap` | S3 state bucket, ECR repo, GitHub deploy/plan roles, role policies | Human-triggered setup, then remote state |
| `production` | VPC, ALB, ECS, CloudFront, S3 assets, alarms, SNS/SQS | Applied by the deploy rail |
| `modules/network` | VPC, subnets, route tables, IGW | Reusable cell-shaped network block |
| `modules/web-service` | ECS task/service, target group, listener, logs, task roles | Reusable container service block |
| `modules/static-edge` | S3 assets bucket, CloudFront OAC, VPC origin, distribution | Reusable public edge block |

## OIDC Exchange

```text
GitHub workflow
  permissions: id-token: write
  -> GitHub OIDC issuer signs JWT
  -> aws-actions/configure-aws-credentials
  -> AWS STS AssumeRoleWithWebIdentity
  -> AWS discovers GitHub public keys from jwks_uri
  -> AWS verifies JWT signature with matching public key
  -> IAM role trust checks aud + sub
  -> temporary AWS credentials
  -> Terraform/AWS CLI calls
```

## Critical Claims

| Claim | Meaning in this project |
| --- | --- |
| `aud` | Audience. For the official AWS credentials action, trust expects `sts.amazonaws.com`. |
| `sub` | Subject. Current deploy rail expects `repo:citypaul/conquer-thoughts:ref:refs/heads/main`. |
| `kid` | Key ID in the JWT header. Helps AWS select the matching GitHub public key from the JWKS. |
| `jwks_uri` | OIDC discovery metadata field pointing to the issuer's JSON Web Key Set. |
| Trust policy | Who may assume the role. Failure here means no AWS credentials exist yet. |
| Permissions policy | What the role can do after it has been assumed. |
| OIDC provider | Account-level IAM object for `https://token.actions.githubusercontent.com`. |
| Deploy role | Main-branch role used by GitHub deploys. |
| Plan role | Read-mostly role; defaults to main-only until PR planning is deliberately designed. |

## Terraform State

| Concept | Project use |
| --- | --- |
| S3 backend | Stores remote state at keys like `bootstrap/terraform.tfstate` and `production/terraform.tfstate`. |
| `use_lockfile = true` | Native S3 lockfiles serialize Terraform operations without a DynamoDB lock table. |
| Versioning | Required on state bucket for recovery from deletion or mistakes. |
| Backend auth | Separate from provider auth; workstation uses profile, GitHub uses OIDC environment credentials. |
| `removed` block | Lets bootstrap forget old provider ownership without destroying the account singleton. |

## AWS Runtime Path

```text
Viewer
  -> CloudFront
     -> S3 assets bucket through OAC
     -> CloudFront VPC origin
        -> internal ALB
           -> ECS Fargate BFF task
```

## VPC And Subnet Map

| Piece | Project value | Meaning |
| --- | --- | --- |
| VPC CIDR | `10.42.0.0/16` | Private address space for the walking skeleton. |
| Public task subnets | `10.42.0.0/24`, `10.42.1.0/24` | Fargate task placement with public IPs for day-one egress. |
| Private origin subnets | `10.42.10.0/24`, `10.42.11.0/24` | Internal ALB placement for the CloudFront VPC origin. |
| Public route table | `0.0.0.0/0 -> internet gateway` | Makes associated subnets public. |
| Private route table | Local VPC route only | Makes associated subnets private/isolated from the internet path. |
| Subnet scope | One Availability Zone | The module creates matching public/private subnets across available AZs. |

## Routing Heuristics

| Question | Answer |
| --- | --- |
| What makes a subnet public? | A route table with a route to an internet gateway. |
| What makes a subnet private? | No direct route to an internet gateway. |
| Does a public IP alone make a private subnet internet-routable? | No. The route table still needs an internet-gateway route. |
| What does `map_public_ip_on_launch` do? | Requests public IPv4 assignment for new network interfaces in that subnet. |
| What allows CloudFront to reach the internal ALB? | CloudFront VPC origin plus an ALB security-group ingress rule from `CloudFront-VPCOrigins-Service-SG`. |
| Does CloudFront use the VPC internet gateway to reach the VPC origin? | No. AWS requires the VPC to have an internet gateway, but says it is not used for routing traffic to origins inside the subnet. |

## Deployment Rail

| Step | Guardrail |
| --- | --- |
| Checkout | Fetch full history and detach at exact SHA. |
| Commit check | Manual dispatch SHA must be full length and reachable from `origin/main`. |
| AWS auth | OIDC only; no long-lived AWS secrets in GitHub. |
| Build image | Docker image tagged with git SHA and build metadata. |
| Push ECR | Immutable tags prevent overwriting a supposedly known artifact. |
| Apply Terraform | Image tag is a Terraform variable; no side-channel ECS update. |
| Publish web | Assets get long cache headers; index gets no-store. |
| Smoke | Checks `/health`, `/api/hello`, `/api/build`, web bundle marker, and alarm sink. |

## Debug Heuristics

| Symptom | First place to look |
| --- | --- |
| `Assuming role with OIDC` retries, then `Not authorized to perform sts:AssumeRoleWithWebIdentity` | IAM role trust policy and actual GitHub token `sub`. |
| Terraform cannot read state in GitHub | Backend bucket/key/auth, not necessarily AWS provider config. |
| Production script refuses to run | Check rehearsal/production input shapes before Terraform. |
| BFF deployed but smoke SHA mismatch | Image tag, build args, Terraform `image_tag`, or running task definition. |
| Static page stale | S3 sync ordering, CloudFront invalidation, cache headers, or bundle marker. |
