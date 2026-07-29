# Public policy publication facts and questions

Last source review: July 29, 2026

This is an engineering inventory for the public policy. It is not legal advice or a legal review. It separates code-backed facts from operating facts that Gale W must confirm before the policy is presented as a complete statement of practice.

## Code-backed facts

- The policy service serves the general public policy at `GET /`, the TuneShare-specific policy at `GET /tuneshare`, and a permanent general-policy alias at `GET /privacy`.
- Its architecture is AWS Lambda Function URL behind CloudFront for `pp.galewilliams.com`. The Function URL uses AWS IAM authorization; CloudFront has origin access control.
- The service does not define a database, account system, cookie mechanism, analytics integration, tracker, or request-payload logging. CloudFront standard logging is disabled. Its Lambda application log group is configured with seven-day retention.
- The current galewilliams.com public-site source accepts name, email address, project type, timeline, and project details at its contact form.
- That source saves a contact submission and review state in PostgreSQL. It also creates notification records, uses Redis for delivery jobs, and supports notification email delivery through Amazon SES.
- The repository guidance establishes `mail@galewilliams.com` as the privacy and deletion-request contact route.

## Facts Gale must confirm before publication

1. The deployed galewilliams.com contact form, database, Redis queue, and Amazon SES notification path match the inspected source, including every production provider involved.
2. The retention schedule for contact submissions, review records, notification records, delivery-status information, email copies, database backups, and provider logs.
3. The deletion-request workflow: request verification, searchable identifiers, scope, exceptions, completion timing, and how requesters are told the result.
4. Production log behavior for the public site, CloudFront, Lambda, AWS services, and any hosting platform, including whether request or form payloads reach logs.
5. Whether analytics, advertising, payments, mailing lists, customer systems, error reporting, or additional Gale-operated services process personal information and require policy coverage.
6. Whether the policy needs an operator legal name, address, jurisdiction-specific disclosures, or a reviewed effective date beyond the implementation date.

## Publication boundary

Do not deploy this service or make DNS, Cloudflare, App Store Connect, or other live-infrastructure changes without explicit approval. Before deployment, run the repository checks and `cdk diff` with the issued certificate ARN and packaged Lambda archive.
