# Learning Plan: Conquer Thoughts AWS, Terraform, and GitHub OIDC

**Learner level:** Experienced software engineer; new material is the AWS/Terraform/OIDC production rail rather than engineering fundamentals.
**Time budget:** Capture mode now; future live review can be done in 15-30 minute sessions.
**Location:** Project-local to this Learnings repo, derived from `/Users/paulhammond/personal/conquer-thoughts`.
**Created:** 2026-06-14
**Last session:** 2026-06-14

## Mission

Build a durable mental model of the Conquer Thoughts production walking skeleton so Paul can explain, debug, and safely extend the AWS/Terraform/GitHub Actions rail without relying on console memory or copied incantations.

**Success looks like:**

- Explain how a merge to `main` becomes a deployed CloudFront/ECS service using Terraform.
- Debug an OIDC assume-role failure by separating workflow permissions, token claims, IAM trust, STS, and role permissions.
- Read the Terraform roots and know which root owns which lifecycle.
- Extend the rail without weakening the security posture or mixing rehearsal and production inputs.

**Out of scope:**

- Hands-on exercises in this capture pass.
- RDS, Auth0, SQS workers, custom domains, WAF, and real tenant data. They are mentioned only as deferred slices.

## The Critical 20%

1. Terraform ownership and state - roots, modules, backend state, lockfiles, imports, and outputs are the map for every other change.
2. AWS runtime topology - CloudFront, private S3 assets, VPC origin, internal ALB, ECS Fargate, ECR, CloudWatch, SNS, and SQS form the first production walking skeleton.
3. VPC/subnet/routing foundations - CIDR blocks, Availability Zones, route tables, internet gateways, and security groups explain why the ALB can be private while CloudFront remains public.
4. GitHub OIDC to AWS - the workflow does not store AWS keys; GitHub signs a JWT, AWS verifies it with GitHub's public keys from OIDC discovery/JWKS, and AWS STS exchanges that token for temporary role credentials if trust matches.
5. IAM trust versus permissions - trust controls who can enter a role; permissions control what the role can do after entry.
6. Deployment proof - git SHA image tags, BFF build metadata, static asset markers, and smoke tests prove the exact commit is serving.
7. Guardrails - no manual ops, no long-lived GitHub credentials, shape-checked production/rehearsal inputs, pinned actions, and Terraform-owned infrastructure.

## Session Outline

### Session 1: The AWS Walking Skeleton Map - 20 minutes
**Objective:** After this session you will be able to trace the deployed request path and name the role of each AWS service in the first slice.
**Prerequisites:** None.
**Status:** Captured, not taught.

### Session 2: Terraform Roots, State, and Modules - 25 minutes
**Objective:** After this session you will be able to explain why the repo has `account-bootstrap`, `bootstrap`, `production`, and reusable modules.
**Prerequisites:** Session 1.
**Status:** Captured, not taught.

### Session 3: CloudFront to Fargate - 25 minutes
**Objective:** After this session you will be able to explain how CloudFront reaches private assets and an internal ALB without making the ALB public.
**Prerequisites:** Session 1.
**Status:** Captured, not taught.

### Session 4: GitHub Actions OIDC to AWS - 30 minutes
**Objective:** After this session you will be able to draw the OIDC token exchange from GitHub workflow to AWS STS credentials, including how AWS verifies GitHub's JWT signature without a shared secret.
**Prerequisites:** Session 2.
**Status:** Captured, not taught.

### Session 5: IAM Trust, Permissions, and the OIDC Fix - 30 minutes
**Objective:** After this session you will be able to diagnose why `sts:AssumeRoleWithWebIdentity` failed and why widening permissions would not fix it.
**Prerequisites:** Session 4.
**Status:** Captured, not taught.

### Session 6: Deployment Rail, Provenance, and Guardrails - 25 minutes
**Objective:** After this session you will be able to explain the deploy workflow from checked-out SHA to smoke-tested CloudFront URL.
**Prerequisites:** Sessions 1-5.
**Status:** Captured, not taught.

### Session 7: VPCs and CIDR Blocks - 20 minutes
**Objective:** After this session you will be able to explain what the walking-skeleton VPC owns and how its `10.42.0.0/16` CIDR becomes smaller subnet ranges.
**Prerequisites:** Session 1.
**Status:** Captured, not taught.

### Session 8: Subnets, Route Tables, and Public versus Private - 25 minutes
**Objective:** After this session you will be able to explain why the task subnets are public, why the ALB subnets are private, and what route tables have to do with that.
**Prerequisites:** Session 7.
**Status:** Captured, not taught.

### Session 9: CloudFront VPC Origins - 25 minutes
**Objective:** After this session you will be able to explain how CloudFront privately reaches the internal ALB and why the Terraform dependency order matters.
**Prerequisites:** Sessions 3, 7, and 8.
**Status:** Captured, not taught.

## Optional Deep-Dives

- Tightening the broad deploy role policy after enough deploys reveal the exact AWS API surface.
- Adding PR plan workflows and safely widening the plan role subject patterns.
- Moving Fargate tasks fully private with NAT or VPC endpoints.
- Adding RDS, migrations as one-off ECS tasks, Secrets Manager, and restore verification.
- Using GitHub deployment environments and deliberately changing the OIDC subject shape.

## Resources

See [resources.md](./resources.md) for the curated source list.
