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

    static let tuneShareHTML = #"""
    <!doctype html>
    <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <meta name="robots" content="index,follow">
      <title>TuneShare Privacy Policy</title>
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
        <h1>TuneShare Privacy Policy</h1>
        <p class="effective">Effective July 29, 2026</p>

        <h2>Who we are</h2>
        <p>TuneShare is provided by Gale W. This policy explains the implementation-backed information practices for its iPhone, iPad, Mac app, and share extension. It is not legal advice or a legal review.</p>

        <h2>Music-link matching</h2>
        <p>When you ask TuneShare to match a music link, the app sends the link you chose to provide, or track metadata needed to resolve it, to the TuneShare TokenBroker service. TokenBroker uses that information to return matching links from supported services: Apple Music, Spotify, YouTube, and YouTube Music.</p>
        <p>TuneShare does not receive your music-service login credentials or access your music-service library, playlists, listening history, or account data. TokenBroker is designed to keep provider credentials on the server rather than in the app.</p>

        <h2>Recent matches and iCloud</h2>
        <p>TuneShare saves recent match history on your devices and synchronizes it through the private CloudKit database associated with your Apple account. This history can include source links, match candidates, track title, artist, provider links, artwork links, duration, and matching confidence. The app keeps the newest 200 records. You can clear this history in TuneShare.</p>
        <p>Gale W does not operate or have access to your private CloudKit database. Apple processes CloudKit under its own privacy policy.</p>

        <h2>Service security and anti-abuse records</h2>
        <p>To protect TokenBroker, TuneShare sends an app-generated installation identifier, platform, bundle identifier, app version, and App Attest or DeviceCheck evidence. TokenBroker stores 120-second challenges, one-hour rate-limit records, and persistent App Attest registration records with anti-replay counters when App Attest is used. These records support security, fraud prevention, replay protection, and rate limiting.</p>
        <p>TokenBroker application and authorizer log groups are configured with seven-day retention. The implementation avoids logging submitted music links, raw attestation or DeviceCheck evidence, provider credentials, and authorization tokens.</p>

        <h2>Sharing</h2>
        <p>To run matching, TokenBroker sends the submitted link or matching metadata to the relevant music-service provider. Recent-match history is synchronized with Apple CloudKit, and Apple validates App Attest or DeviceCheck evidence where that security path is used. The app source does not include a TuneShare account, music-service OAuth, advertising, marketing SDK, direct payment system, or independent crash-reporting service.</p>

        <h2>Retention and deletion</h2>
        <p>Recent-match history remains in your private CloudKit database until you clear it or remove it through your Apple account. Challenges and rate-limit records have the configured expiration windows described above. App Attest registration records do not have an automatic expiration path in the inspected implementation; you may request deletion of a security record associated with your installation by contacting us.</p>

        <h2>Your choices and contact</h2>
        <p>You can choose not to submit a link, clear recent matches in TuneShare, disable iCloud features through your Apple account settings, and control Apple’s optional diagnostic-sharing settings through your device settings. For privacy questions or a request to delete TokenBroker security records associated with your installation, email <a href="mailto:mail@galewilliams.com">mail@galewilliams.com</a>.</p>

        <h2>Before an App Store submission</h2>
        <p>The exact release archive, deployed TokenBroker retention settings, production logs, provider behavior, and any added analytics, crash reporting, advertising, payment, or SDK integrations must be rechecked before making App Store privacy disclosures. The implementation checklist for that review is maintained separately.</p>

        <h2>Changes</h2>
        <p>We may update this policy when TuneShare's data practices change. The current version is published at this address with its effective date.</p>
      </main>
    </body>
    </html>
    """#
}
