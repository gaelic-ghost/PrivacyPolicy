# Privacy Policy

The public, single-purpose policy site for Gale W's website and related services.

The canonical policy URL is `https://pp.galewilliams.com/`.

## Routes

- `GET /` — canonical public privacy policy
- `GET /tuneshare` — TuneShare-specific privacy policy
- `GET /privacy` — permanent compatibility redirect to `/`

The app is a Hummingbird Lambda Function URL origin. CloudFront provides the public custom domain and TLS; the Lambda URL is not intended as a public policy URL.

## Local validation

```sh
swift build
swift test
```

## Release checks

Release checks are authoritative only in GitHub Actions' clean checkout. A linked worktree exits early rather than giving a misleading Git-history scan; use it for development checks such as `swift test` instead.

From the clean primary checkout after it exactly matches `origin/main`, create a release tag:

```sh
scripts/create-release-tag.sh vMAJOR.MINOR.PATCH
```

The tag-triggered GitHub workflow verifies that the tag is the current `main` commit, runs the complete release gate in a clean checkout, packages the Linux Lambda ZIP, generates a SHA-256 checksum and revision evidence, and creates or updates a draft GitHub Release. Review the draft, then publish it to start the production deployment workflow.

The production workflow uses the GitHub `production` environment, downloads the ZIP attached to the published release, verifies its checksum and evidence, runs `cdk diff`, deploys that exact ZIP, and checks both public policy routes. Re-running it with a prior published release tag is the rollback path; it cannot deploy a draft or an artifact built from a worktree.

### GitHub production setup

Before publishing the first draft release, deploy `PrivacyPolicyDeployment`, then configure GitHub's `production` environment and these environment secrets. Add a required-reviewer rule there when a separate production approver is available.

- `AWS_ROLE_TO_ASSUME` — the AWS IAM role trusted through GitHub Actions OpenID Connect for this repository's production deployment.
- `PRIVACY_POLICY_CERTIFICATE_ARN` — the issued ACM certificate ARN for `pp.galewilliams.com` in `us-east-1`.

The deployment workflow intentionally does not create the certificate, configure Cloudflare DNS, or change App Store Connect. Those remain separate, explicitly approved operations.

## Deployment

The CDK application in `infrastructure/` defines the Lambda, Function URL, CloudFront distribution, ACM certificate, and the Route 53 alias record. It intentionally does not manage Cloudflare DNS. Deploying the stack first creates an ACM DNS-validation record; add that record in Cloudflare, then let the CloudFront deployment complete.

```sh
pnpm --dir infrastructure install --frozen-lockfile
pnpm --dir infrastructure exec cdk synth PrivacyPolicyCertificate --strict
pnpm --dir infrastructure exec cdk diff PrivacyPolicyCertificate
```

After Cloudflare validates the ACM certificate, build the Linux Lambda archive with `scripts/package-lambda.sh`, then use its issued certificate ARN for the service stack:

```sh
pnpm --dir infrastructure exec cdk synth PrivacyPolicyService --strict \
  -c certificateArn=<issued-certificate-arn>
```

Read [the publication facts and questions](docs/publication-facts-and-questions.md) before deploying the general public policy. It records the source-grounded scope and the operational facts that Gale must confirm before publication.

Read [the TuneShare App Store privacy worksheet](docs/tuneshare-app-store-privacy.md) before publishing a TuneShare build or changing the `/tuneshare` policy. It is the separate implementation-grounded checklist for that route and must be rechecked whenever TuneShare or TokenBroker changes.
