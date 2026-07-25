# Privacy Policy

The public, single-purpose policy site for Gale W's apps.

The canonical TuneShare policy URL is `https://pp.galewilliams.com/tuneshare`.

## Routes

- `GET /tuneshare` — TuneShare privacy policy
- `GET /` and `GET /privacy` — permanent redirects to `/tuneshare`

The app is a Hummingbird Lambda Function URL origin. CloudFront provides the public custom domain and TLS; the Lambda URL is not intended as a public policy URL.

## Local validation

```sh
swift build
swift test
```

## Release checks

Run the release gate before creating a public tag:

```sh
scripts/release-check.sh
```

It scans the complete Git history with [Gitleaks](https://github.com/gitleaks/gitleaks) in Docker, then scans tracked source and history for high-confidence secrets and sensitive PII (private keys, credentials, Social Security numbers, and payment-card numbers). It also runs the Swift tests and infrastructure type check. Use `scripts/release-check.sh --scan-only` for just the data scan.

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

Read [the App Store privacy worksheet](docs/tuneshare-app-store-privacy.md) before publishing a TuneShare build. It is implementation-grounded, but must be rechecked whenever TuneShare or TokenBroker changes.
