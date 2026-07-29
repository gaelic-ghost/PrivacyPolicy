enum PolicyDocument {
    static let publicHTML = #"""
    <!doctype html>
    <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <meta name="robots" content="index,follow">
      <title>Gale W Privacy Policy</title>
      <style>
        :root { color-scheme: light dark; font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }
        body { max-width: 48rem; margin: 0 auto; padding: 2rem 1.25rem 4rem; line-height: 1.6; }
        h1, h2 { line-height: 1.2; }
        h1 { margin-bottom: .2rem; }
        .effective { color: #666; margin-top: 0; }
        a { color: #6d28d9; }
      </style>
    </head>
    <body>
      <main>
        <h1>Privacy Policy</h1>
        <p class="effective">Effective July 29, 2026</p>

        <h2>Who we are</h2>
        <p>Gale W operates galewilliams.com, pp.galewilliams.com, and related Gale-operated services. This policy describes the information practices supported by the current public-site and policy-service source code. It is not legal advice or a legal review.</p>

        <h2>Scope</h2>
        <p>This policy covers the public website, its project-intake contact form, this policy site, and related services operated by Gale W. A service with different data practices will need its own reviewed notice before those practices are described here.</p>

        <h2>Contact and project-intake information</h2>
        <p>When you submit the contact form on galewilliams.com, the form asks for your name, email address, project type, timeline, and project details. The public-site source stores the submitted information with its review status so that Gale W can review and respond to the inquiry.</p>
        <p>The source also supports a notification email about a new inquiry through Amazon Simple Email Service (SES). That notification is for reviewing the inquiry; it is not a marketing list or a public posting of your submission.</p>

        <h2>How the information is used</h2>
        <p>Contact and project-intake information is used to review an inquiry, communicate about that inquiry, and manage the related project discussion. We do not describe any other use of that information in this policy unless it has been verified in the service implementation and operating practices.</p>

        <h2>Storage, retention, and deletion</h2>
        <p>The current public-site source does not set or document an automatic retention period or deletion schedule for contact submissions, their review records, or notification records. We therefore cannot state a specific retention period or deletion timeline in this policy.</p>
        <p>You may request deletion of contact or project-intake information by emailing the address below. Include enough detail for us to identify the submission. Before publication, Gale W must confirm the operational process, scope, and timing for fulfilling these requests.</p>

        <h2>Service providers</h2>
        <p>The contact-form implementation uses a PostgreSQL database and Redis queue, and supports sending intake notifications through Amazon SES. The exact production hosting and retention settings for those services must be confirmed before this policy makes broader claims about them. We do not list unverified providers, analytics, advertising, payment, or deletion practices here.</p>

        <h2>Policy-site operation</h2>
        <p>This policy site is a static-document service. Its current source has no form, account system, cookie mechanism, analytics integration, or tracker. Its infrastructure disables CloudFront standard logs and configures the Lambda application log group to retain logs for seven days. The application source does not add request-payload logging.</p>

        <h2>Security</h2>
        <p>The policy service is configured to use HTTPS through CloudFront and restricted Lambda Function URL access, with response security headers. Security measures reduce risk; they do not guarantee that information will never be accessed, altered, lost, or disclosed.</p>

        <h2>Your choices and contact</h2>
        <p>You can choose not to submit a contact form. For privacy questions or a request to delete contact or project-intake information, email <a href="mailto:mail@galewilliams.com">mail@galewilliams.com</a>.</p>

        <h2>Questions that must be confirmed before publication</h2>
        <p>Before publishing this policy as a complete statement of practice, Gale W must confirm the production database and queue hosts, contact-data retention schedule, deletion-request process and timing, Amazon SES configuration and retention, production logs, and whether any analytics, payments, additional processors, or other Gale-operated services need to be covered.</p>

        <h2>Changes</h2>
        <p>We may update this policy when data practices change or when the open publication questions above are resolved. The current version is published at this address with its effective date.</p>
      </main>
    </body>
    </html>
    """#
}
