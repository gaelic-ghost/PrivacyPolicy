enum PolicyDocument {
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
        <p class="effective">Effective July 25, 2026</p>

        <h2>Who we are</h2>
        <p>TuneShare is provided by Gale W. This policy explains how TuneShare handles information when you use its iPhone, iPad, and Mac app and share extension.</p>

        <h2>The short version</h2>
        <p>TuneShare matches music links that you choose to provide. It does not require an account, access your music-service account or library, sell personal information, show advertising, or track you across apps or websites.</p>

        <h2>Information used to provide matching</h2>
        <p>When you ask TuneShare to match a link, the app sends the music link you provided, or the track metadata needed to resolve it, to TuneShare's TokenBroker service. That service uses the information only to return matching links from supported music services: Apple Music, Spotify, YouTube, and YouTube Music.</p>
        <p>TuneShare does not receive your Apple Music, Spotify, Google, YouTube, or other music-service login credentials. It does not access your library, playlists, listening history, or service account data.</p>
        <p>The submitted link and matching metadata are used to service the request and are not retained by TokenBroker as a match history. The music providers may process requests made to their services under their own privacy policies.</p>

        <h2>Recent matches and iCloud</h2>
        <p>TuneShare saves your recent match history on your devices and synchronizes it through the private CloudKit database associated with your Apple account. This history can include submitted music links and match results such as track title, artist, provider links, artwork links, duration, and matching confidence. The history is limited to 200 recent matches. You can clear it in TuneShare; clearing removes those records from the app's synchronized history.</p>
        <p>Gale W does not operate or have access to your private CloudKit database. Apple processes CloudKit under its own privacy policy.</p>

        <h2>Service security and anti-abuse records</h2>
        <p>To protect TokenBroker from abuse, TuneShare sends a random app-installation identifier, app and version information, and App Attest or DeviceCheck evidence. TokenBroker stores short-lived challenges and rate-limit records, and keeps an App Attest registration record and anti-replay counter for an app installation when App Attest is used. These records are used only for security, fraud prevention, and reliable operation; they are not used to identify you by name, build a profile, advertise, or track you.</p>
        <p>TokenBroker retains application and authorizer operational logs for seven days. These logs are designed not to include music links, raw attestation payloads, provider credentials, or authorization tokens.</p>

        <h2>What TuneShare does not do</h2>
        <ul>
          <li>No advertising, sale of personal information, or cross-app or cross-site tracking.</li>
          <li>No third-party analytics SDK, marketing SDK, or independent crash-reporting service.</li>
          <li>No TuneShare account, subscription, licensing account, or direct payment system.</li>
          <li>No collection of App Store purchase records; Apple handles App Store purchases.</li>
        </ul>
        <p>If you choose Apple’s optional operating-system-level diagnostic sharing, Apple may collect diagnostic information under its own settings and privacy policy. TuneShare does not control that Apple service.</p>

        <h2>Sharing</h2>
        <p>We share only what is necessary to run the feature: a submitted music link or matching metadata is sent to the relevant music-service provider through TokenBroker; private recent-match history is synchronized with Apple CloudKit; and Apple validates App Attest or DeviceCheck evidence where required for service security. We do not sell or share information for advertising.</p>

        <h2>Retention and deletion</h2>
        <p>Recent match history remains in your private CloudKit database until you clear it or remove it through your Apple account. Short-lived TokenBroker security records expire after their security window. App Attest registration records remain while needed to prevent replay and abuse; you may request deletion of such a record by contacting us. Operational logs are retained for seven days.</p>

        <h2>Your choices and contact</h2>
        <p>You can avoid submitting a link, clear recent matches in TuneShare, disable iCloud features through your Apple account settings, and control Apple’s optional diagnostic-sharing settings through your device settings. For privacy questions or a request to delete TokenBroker security records associated with your installation, email <a href="mailto:mail@galewilliams.com">mail@galewilliams.com</a>.</p>

        <h2>Children</h2>
        <p>TuneShare is not directed to children, and we do not knowingly collect personal information from children.</p>

        <h2>Changes</h2>
        <p>We may update this policy when TuneShare's data practices change. The current version is always published at this address, with its effective date shown above.</p>
      </main>
    </body>
    </html>
    """#
}
