import AWSLambdaEvents
import Configuration
import Hummingbird
import HummingbirdLambda
import Logging

// Request context used by lambda<FunctionURLRequest>
typealias AppRequestContext = BasicLambdaRequestContext<FunctionURLRequest>

///  Build AWS Lambda function
/// - Parameter reader: configuration reader
func buildLambda(reader: ConfigReader) async throws -> FunctionURLLambdaFunction<RouterResponder<AppRequestContext>> {
    let logger = {
        var logger = Logger(label: "PrivacyPolicy")
        logger.logLevel = reader.string(forKey: "log.level", as: Logger.Level.self, default: .info)
        return logger
    }()
    let router = try buildRouter()
    let lambda = FunctionURLLambdaFunction(
        router: router,
        logger: logger
    )
    return lambda
}

/// Build router
func buildRouter() throws -> Router<AppRequestContext> {
    let router = Router(context: AppRequestContext.self)
    router.get("/") { _, _ in
        Response.redirect(to: "/tuneshare", type: .permanent)
    }
    router.get("/privacy") { _, _ in
        Response.redirect(to: "/tuneshare", type: .permanent)
    }
    router.get("/tuneshare") { _, _ in
        PolicyResponse.html(PolicyDocument.tuneShareHTML)
    }
    return router
}

private enum PolicyResponse {
    static func html(_ document: String) -> Response {
        let body = ByteBuffer(string: document)
        var headers = HTTPFields()
        headers[.contentType] = "text/html; charset=utf-8"
        headers[.contentLength] = String(body.readableBytes)
        headers[.cacheControl] = "public, max-age=300"
        return Response(status: .ok, headers: headers, body: .init(byteBuffer: body))
    }
}
