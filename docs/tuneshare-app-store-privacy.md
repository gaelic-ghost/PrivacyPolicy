# TuneShare App Store privacy worksheet

Last reviewed: July 25, 2026

This worksheet is the implementation-grounded starting point for App Store Connect. It is not a substitute for reviewing the release archive and current TokenBroker deployment before submission.

## Public policy URL

`https://pp.galewilliams.com/tuneshare`

Optional privacy-choices URL: use the same URL unless a dedicated deletion-request page is added later. The policy explains the available choices and provides `mail@galewilliams.com` for security-record deletion requests.

## Proposed App Privacy answers

| Data type | Collected | Linked to the user or device | Used for | Tracking |
| --- | --- | --- | --- | --- |
| Device ID | Yes: TokenBroker receives an app-generated installation identifier and retains it in App Attest and rate-limit records. | Yes, to the app installation/device context; it is not linked to a name, account, advertising ID, or third-party dataset. | App Functionality: security, fraud prevention, anti-replay protection, and rate limiting. | No |
| Other Data | Yes: App Attest key registration material and anti-replay counter are retained to validate future app assertions. | Yes, to the app installation/device context only. | App Functionality: security and fraud prevention. | No |
| Other User Content | No, if TokenBroker continues to discard submitted music links and matching metadata after servicing the request. | N/A | N/A | No |
| Purchase History / Payment Info | No. Apple handles the one-time App Store purchase outside TuneShare. | N/A | N/A | No |
| Crash Data / Performance Data | No independent collection by TuneShare. Apple optional diagnostics are controlled by the operating system and processed by Apple. Re-evaluate if TuneShare adds an SDK or sends diagnostic payloads to TokenBroker. | N/A | N/A | No |
| Product Interaction | No analytics or interaction telemetry is retained. | N/A | N/A | No |

### Why Device ID is declared

Apple defines Device ID broadly to include other device-level identifiers, and defines data as linked when it is associated with a device. TokenBroker persists an app-generated installation identifier, so the conservative and accurate App Store answer is to disclose it as Device ID, linked to the device, for App Functionality only.

### Why submitted music links are not proposed as collected

TuneShare transmits an explicit submitted link or track metadata to TokenBroker to service a matching request. TokenBroker does not persist that request payload as a match history, and its application logs are designed not to include it. Reclassify the data if a future version stores, logs, analyzes, or uses it after the request is serviced.

## Verified implementation facts

- Recent history is stored in the user's private CloudKit database: source links, match candidates, title, artist, URLs, artwork URL, duration, and confidence; the app caps it at 200 recent matches.
- TuneShare does not use a TuneShare account, music-service OAuth, advertising, marketing SDKs, or a direct payment/licensing service.
- TokenBroker uses Apple App Attest and DeviceCheck as app/device evidence. It stores 120-second challenges, one-hour rate-limit records, and persistent App Attest registration records with anti-replay counters.
- TokenBroker application and authorizer CloudWatch log groups retain logs for seven days. The code avoids logging raw attestation evidence, music links, provider credentials, or authorization tokens.

## Mandatory pre-submission checks

1. Inspect the exact release archive for added SDKs, privacy manifests, analytics, crash reporting, or changed entitlements.
2. Recheck the deployed TokenBroker DynamoDB TTL configuration and CloudWatch retention.
3. Confirm that no API Gateway, CloudFront, WAF, or application access logs record music links or raw security evidence.
4. Confirm that the in-app Settings or About surface links to this policy URL, as App Review requires the policy to be easily accessible in the app.
5. Publish the App Store Connect App Privacy answers only after the first four checks pass.

## Source links

- [Apple App Privacy Details](https://developer.apple.com/app-store/app-privacy-details/)
- [Manage app privacy in App Store Connect](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy)
- [App Review Guidelines, privacy policies](https://developer.apple.com/app-store/review/guidelines/)
