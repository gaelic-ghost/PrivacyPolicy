# PrivacyPolicy service guidance

This repository is the public, single-purpose policy site for Gale W's apps.

## Service shape

- The service was generated with the official `hb` CLI as a Hummingbird Lambda Function URL app. Preserve `HummingbirdLambda` and the generated configuration path.
- CloudFront is the public HTTPS edge for `pp.galewilliams.com`; the Lambda Function URL is an origin and must not be promoted as the public policy URL.
- `GET /tuneshare` is the canonical TuneShare privacy-policy route. Keep a stable policy URL for App Store Connect.
- There is no database, account system, analytics, cookies, tracker, or request-payload logging in this service. Do not add any of those without Gale's explicit approval.
- The policy content is a reviewed, static Swift source document. Do not add a general CMS, a template engine, or arbitrary Markdown rendering for this one-document service.

## Policy integrity

- Treat the data-flow inventory in `docs/tuneshare-app-store-privacy.md` as the App Store submission worksheet.
- Policy claims must be backed by the current TuneShare and TokenBroker implementation. Re-audit them when either service changes.
- Never claim that app-installation security records are short-lived unless TokenBroker implements an automatic expiration path for them.
- Use `mail@galewilliams.com` for privacy and deletion requests unless Gale explicitly changes it.

## Commands

```sh
swift build
swift test
pnpm --dir infrastructure lint
pnpm --dir infrastructure test
pnpm --dir infrastructure exec cdk synth --strict
```

Run Swift and Node/CDK builds serially. Run `cdk diff` before every deployment.

## Deployment

- The CDK certificate stack has deploy-time DNS validation for `pp.galewilliams.com`; deploying it creates an ACM certificate request that Gale must validate in Cloudflare before the service stack can be synthesized or deployed.
- Do not deploy, create DNS records, change Cloudflare configuration, or update App Store Connect unless Gale explicitly asks for that final external action.
- Do not enable CloudFront standard logs or API-style request logging without updating the policy and App Store worksheet.
