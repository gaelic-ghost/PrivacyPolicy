import Configuration
import Hummingbird
import HummingbirdLambdaTesting
import Logging
import Testing

@testable import App

private let reader = ConfigReader(providers: [
    InMemoryProvider(values: [
        "log.level": "trace"
    ])
])

@Suite
struct AppTests {
    @Test
    func servesPublicPrivacyPolicyAtTheCanonicalRoute() async throws {
        let lambda = try await buildLambda(reader: reader)
        try await lambda.test() { client in
            try await client.execute(uri: "/", method: .get) { response in
                #expect(response.statusCode == .ok)
                #expect(response.headers?["Content-Type"] == "text/html; charset=utf-8")
                #expect(response.body?.contains("Privacy Policy") == true)
                #expect(response.body?.contains("Contact and project-intake information") == true)
                #expect(response.body?.contains("mail@galewilliams.com") == true)
            }
        }
    }

    @Test
    func redirectsStableAliasesToTheCanonicalRoute() async throws {
        let lambda = try await buildLambda(reader: reader)
        try await lambda.test() { client in
            try await client.execute(uri: "/tuneshare", method: .get) { response in
                #expect(response.statusCode == .movedPermanently)
                #expect(response.headers?["Location"] == "/")
            }
            try await client.execute(uri: "/privacy", method: .get) { response in
                #expect(response.statusCode == .movedPermanently)
                #expect(response.headers?["Location"] == "/")
            }
        }
    }
}
