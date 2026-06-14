# Conquer Thoughts AWS, Terraform, and GitHub OIDC Resources

## Recommended Study Path

1. Start with the project evidence files to anchor each idea in the actual Conquer Thoughts implementation.
2. For OIDC, read GitHub's AWS guide first, then AWS's OIDC provider docs, then GitHub's claim reference. Only drop into OpenID/JWS/JWK specs when you want the signature-verification mechanics.
3. For Terraform, read state first, then the S3 backend, then module design. That order mirrors the repo's root/module layout.
4. For AWS networking, read VPC overview, CIDR blocks, subnets, route tables, and internet gateways before VPC origins. VPC origins make much more sense once public/private subnet routing is no longer fuzzy.
5. For operations, read the deployment rail lesson alongside GitHub Actions secure-use docs, ECR immutability, ECS rolling deployments, and the AWS Operational Excellence pillar.

## Knowledge

- [GitHub Docs: Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws)
  Use for the GitHub-side workflow requirements: `id-token: write`, OIDC token exchange, AWS audience, and the recommended `sub` condition shape.

- [GitHub Docs: OpenID Connect reference](https://docs.github.com/en/actions/reference/security/oidc)
  Use for claim shapes, especially branch, pull request, tag, and environment subject formats.

- [GitHub OIDC discovery document](https://token.actions.githubusercontent.com/.well-known/openid-configuration)
  Use to see the live issuer metadata GitHub publishes for Actions OIDC, including the `jwks_uri` where public signing keys are advertised.

- [AWS IAM: Create an OpenID Connect identity provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html)
  Use for the AWS account-level OIDC provider concept, the discovery document requirements, and the `jwks_uri` public-key verification path.

- [AWS IAM: Create a role for OpenID Connect federation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html)
  Use for the AWS role trust model and the GitHub-specific guidance requiring a constrained `token.actions.githubusercontent.com:sub`.

- [AWS IAM: OIDC federation condition context keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_iam-condition-keys.html#condition-keys-wif)
  Use when deciding which OIDC claims can be referenced as IAM condition keys and whether they are available only during role assumption or also in the resulting session.

- [AWS STS: AssumeRoleWithWebIdentity](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRoleWithWebIdentity.html)
  Use for the exact exchange: a web identity token becomes temporary AWS credentials without long-lived AWS credentials in the caller.

- [OpenID Connect Discovery 1.0](https://openid.net/specs/openid-connect-discovery-1_0.html)
  Use for the general mechanism behind `.well-known/openid-configuration` and how relying parties discover provider metadata such as `jwks_uri`.

- [IETF RFC 7515: JSON Web Signature](https://datatracker.ietf.org/doc/html/rfc7515)
  Use for the signed-token mental model: a JWT can be a JWS, with a header such as `kid` that helps a verifier select the right public key.

- [IETF RFC 7517: JSON Web Key](https://datatracker.ietf.org/doc/html/rfc7517)
  Use for understanding JWK and JWKS: JSON representations of public keys and key sets used to verify signed tokens.

- [IETF RFC 7519: JSON Web Token](https://datatracker.ietf.org/doc/html/rfc7519)
  Use for the base JWT concept: claims such as `iss`, `sub`, `aud`, `exp`, and `iat` carried inside a compact token.

- [HashiCorp Terraform: S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3)
  Use for remote S3 state, native lockfiles, backend credentials, and the warning to enable bucket versioning.

- [HashiCorp Terraform: State](https://developer.hashicorp.com/terraform/language/state)
  Use for the mental model of Terraform state as the mapping between configuration addresses and real infrastructure objects.

- [HashiCorp Terraform: Creating modules](https://developer.hashicorp.com/terraform/language/modules/develop)
  Use for deciding when local modules raise the level of abstraction versus becoming thin wrappers.

- [HashiCorp Terraform: `depends_on` meta-argument](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on)
  Use when Terraform's implicit dependency graph needs help, such as waiting for a CloudFront-created service-managed security group to exist.

- [HashiCorp Well-Architected Framework](https://developer.hashicorp.com/well-architected-framework)
  Use for a broader lens on repeatable infrastructure workflows, security controls, reliability, and operational design.

- [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html)
  Use for the high-level tradeoff vocabulary around secure, reliable, operable, cost-aware cloud workloads.

- [AWS Well-Architected: Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
  Use for current AWS recommendations on identity, access, data protection, detection, and incident response.

- [AWS Well-Architected: Operational Excellence Pillar](https://docs.aws.amazon.com/wellarchitected/latest/operational-excellence-pillar/welcome.html)
  Use for deployment rails, observability, event response, and continuous operational improvement.

- [AWS CloudFront: Restrict access with VPC origins](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-vpc-origins.html)
  Use for the private-origin pattern where CloudFront reaches an internal ALB through a VPC origin and a service-managed security group.

- [AWS CloudFront: What is Amazon CloudFront?](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)
  Use for the baseline CloudFront mental model: distributions, origins, edge locations, caching, and viewer routing.

- [AWS CloudFront: Use various origins with distributions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DownloadDistS3AndCustomOrigins.html)
  Use to compare S3, ALB, NLB, EC2, API Gateway, and VPC origin patterns.

- [AWS CloudFront: Control origin requests with a policy](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/controlling-origin-requests.html)
  Use when reasoning about which headers, cookies, and query strings CloudFront forwards to an origin.

- [AWS CloudFront: Restrict access to an Amazon S3 origin](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html)
  Use for Origin Access Control and the private S3 static-assets bucket.

- [AWS VPC: What is Amazon VPC?](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
  Use for the top-level mental model: a VPC is a logically isolated virtual network containing subnets, routing, gateways, and VPC-level observability.

- [AWS VPC: VPC CIDR blocks](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html)
  Use for IPv4 CIDR sizing, private address range recommendations, overlap rules, and why the project chose a large `10.42.0.0/16` address space.

- [IETF RFC 1918: Address Allocation for Private Internets](https://www.rfc-editor.org/rfc/rfc1918)
  Use for the original private IPv4 ranges that underpin VPC CIDR choices such as `10.0.0.0/8`.

- [AWS VPC: Subnets for your VPC](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html)
  Use for subnet basics: one subnet lives in one Availability Zone, and public/private subnet type is determined by routing.

- [AWS VPC: Subnet CIDR blocks](https://docs.aws.amazon.com/vpc/latest/userguide/subnet-sizing.html)
  Use for subnet sizing, non-overlapping subnet CIDRs, and AWS-reserved IP addresses inside every subnet.

- [AWS VPC: Configure route tables](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)
  Use for the route-table mental model: destination CIDR plus target decides where subnet traffic goes.

- [AWS VPC: Internet gateways](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)
  Use for how public subnets get internet paths and why a subnet without an internet-gateway route remains private.

- [AWS VPC: Security groups](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html)
  Use for stateful resource-level traffic rules and source-security-group references.

- [AWS VPC Reachability Analyzer](https://docs.aws.amazon.com/vpc/latest/reachability/what-is-reachability-analyzer.html)
  Use when debugging whether a route table, security group, network ACL, or load balancer configuration blocks a network path.

- [AWS ECS: Architect for AWS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html)
  Use for the core Fargate idea: run containers without managing EC2 instances or cluster capacity.

- [AWS ECS: Deployment circuit breaker](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-circuit-breaker.html)
  Use for rollback behavior when ECS service deployments fail to reach steady state or pass health checks.

- [AWS ECS: Rolling deployments](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-type-ecs.html)
  Use for how ECS replaces tasks during rolling updates and resolves image tags to digests.

- [AWS ECR: Image tag mutability](https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-tag-mutability.html)
  Use for why the BFF repository has immutable tags and why pushing the same tag twice should fail.

- [AWS Elastic Load Balancing: What is an Application Load Balancer?](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)
  Use for ALB concepts such as listeners, rules, target groups, and request routing.

- [AWS IAM: Policies and permissions](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)
  Use for identity-based policies, resource-based policies, role trust policies, and least-privilege language.

- [AWS IAM: Policy evaluation logic](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html)
  Use for the final allow/deny model after a principal has credentials and tries to call an AWS API.

- [AWS IAM: Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html#id_roles_terms-and-concepts)
  Use for the difference between a role, a role session, a trust policy, and temporary credentials.

- [GitHub Actions: Secure use reference](https://docs.github.com/en/actions/reference/security/secure-use)
  Use for workflow hardening beyond OIDC: secrets, untrusted input, third-party actions, and runner safety.

- [GitHub Actions: Workflow syntax](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax)
  Use for the exact meaning of workflow triggers, permissions, concurrency, and manual dispatch wiring.

## Project Evidence

- `/Users/paulhammond/personal/conquer-thoughts/infra/terraform/README.md`
  The project-level map of the Terraform roots and intentionally absent pieces.

- `/Users/paulhammond/personal/conquer-thoughts/infra/terraform/RUNBOOK.md`
  The operator path for rehearsal, remote state migration, production recreation, and GitHub handoff.

- `/Users/paulhammond/personal/conquer-thoughts/scripts/walking-skeleton/README.md`
  The script-level runbook, including OIDC failure recovery and the GitHub rail shape.

- `/Users/paulhammond/personal/conquer-thoughts/docs/security/README.md`
  The security baseline and the OIDC failure lesson from the first GitHub deploy attempt.

- `/Users/paulhammond/personal/conquer-thoughts/.github/workflows/deploy.yml`
  The production deploy workflow using GitHub OIDC, pinned actions, commit reachability checks, Terraform, ECR, S3, CloudFront, and smoke tests.

- `/Users/paulhammond/personal/conquer-thoughts/infra/terraform/bootstrap/main.tf`
  The IAM roles, role trusts, state policies, ECR repository, and deploy/plan policies.

- `/Users/paulhammond/personal/conquer-thoughts/infra/terraform/production/main.tf`
  The production composition root for network, ECS, ALB, CloudFront, S3, alarms, SNS, and SQS.

- `/Users/paulhammond/personal/conquer-thoughts/infra/terraform/modules/network/main.tf`
  The concrete VPC, subnet, route table, and internet gateway setup used by the walking skeleton.

- `/Users/paulhammond/personal/conquer-thoughts/infra/terraform/modules/static-edge/main.tf`
  The CloudFront VPC origin and security-group dependency graph for reaching the internal ALB.

## Wisdom

- [AWS re:Post: AWS Identity and Access Management](https://repost.aws/tags/TA-UvQ6v5eTR6OEtYbVub1jQ/aws-identity-and-access-management)
  Useful when the official docs are technically right but a real OIDC or IAM evaluation failure still needs practitioner examples.

- [HashiCorp Discuss: Terraform](https://discuss.hashicorp.com/c/terraform-core/27)
  Useful for Terraform state, backend, and refactoring questions where the exact CLI behavior matters.

## Gaps

- The captured lessons do not prove live recall. Start the next `teach-me` session with the quiz questions from lessons 4 and 5.
- The deploy role permissions are intentionally broad in the project. A later lesson should cover narrowing them after the required AWS API surface is known.
