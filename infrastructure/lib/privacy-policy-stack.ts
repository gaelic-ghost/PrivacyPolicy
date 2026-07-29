import * as path from "node:path";
import { existsSync } from "node:fs";
import * as cdk from "aws-cdk-lib";
import * as acm from "aws-cdk-lib/aws-certificatemanager";
import * as cloudfront from "aws-cdk-lib/aws-cloudfront";
import * as origins from "aws-cdk-lib/aws-cloudfront-origins";
import * as iam from "aws-cdk-lib/aws-iam";
import * as lambda from "aws-cdk-lib/aws-lambda";
import * as logs from "aws-cdk-lib/aws-logs";
import { Construct } from "constructs";

const domainName = "pp.galewilliams.com";
const githubRepository = "gaelic-ghost/PrivacyPolicy";

interface PrivacyPolicyDeploymentStackProps extends cdk.StackProps {
  serviceRegion: string;
}

/**
 * Bootstrap identity for the production GitHub Actions deployment workflow.
 *
 * The role can enter only CDK's pre-existing, service-region deployment roles;
 * CloudFormation retains the broader execution permissions needed to update the
 * already-provisioned service. GitHub itself may assume this role only from the
 * production environment of this repository.
 */
export class PrivacyPolicyDeploymentStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: PrivacyPolicyDeploymentStackProps) {
    super(scope, id, props);

    const provider = new iam.OpenIdConnectProvider(this, "GitHubActionsProvider", {
      url: "https://token.actions.githubusercontent.com",
      clientIds: ["sts.amazonaws.com"],
    });
    const githubActionsRole = new iam.Role(this, "GitHubActionsDeploymentRole", {
      roleName: "privacy-policy-github-actions-deploy",
      description: "Deploys published PrivacyPolicy GitHub Releases through the CDK bootstrap roles.",
      assumedBy: new iam.WebIdentityPrincipal(provider.openIdConnectProviderArn, {
        StringEquals: {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": `repo:${githubRepository}:environment:production`,
        },
      }),
    });
    const bootstrapRoleArn = (role: string) =>
      `arn:${this.partition}:iam::${this.account}:role/cdk-hnb659fds-${role}-role-${this.account}-${props.serviceRegion}`;

    githubActionsRole.addToPolicy(new iam.PolicyStatement({
      actions: ["sts:AssumeRole", "sts:TagSession"],
      resources: [
        bootstrapRoleArn("deploy"),
        bootstrapRoleArn("file-publishing"),
        bootstrapRoleArn("lookup"),
      ],
    }));
    githubActionsRole.addToPolicy(new iam.PolicyStatement({
      actions: [
        "cloudformation:DescribeChangeSet",
        "cloudformation:DescribeStackEvents",
        "cloudformation:DescribeStackResources",
        "cloudformation:DescribeStacks",
        "cloudformation:GetTemplate",
        "cloudformation:GetTemplateSummary",
      ],
      resources: ["*"],
    }));
    githubActionsRole.addToPolicy(new iam.PolicyStatement({
      actions: ["ssm:GetParameter"],
      resources: [`arn:${this.partition}:ssm:${props.serviceRegion}:${this.account}:parameter/cdk-bootstrap/hnb659fds/version`],
    }));

    new cdk.CfnOutput(this, "GitHubActionsDeploymentRoleArn", {
      value: githubActionsRole.roleArn,
      description: "Set this as the AWS_ROLE_TO_ASSUME secret in GitHub's production environment.",
    });
  }
}

export class PrivacyPolicyCertificateStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: cdk.StackProps) {
    super(scope, id, props);

    const certificate = new acm.CfnCertificate(this, "Certificate", {
      domainName,
      validationMethod: "DNS",
    });

    new cdk.CfnOutput(this, "CertificateArn", {
      value: certificate.ref,
      exportName: "privacy-policy-certificate-arn",
    });
    new cdk.CfnOutput(this, "CloudflareDnsValidationRequired", {
      value: "Add the ACM DNS validation CNAME displayed for this certificate in Cloudflare before deploying PrivacyPolicyService.",
    });
  }
}

interface PrivacyPolicyServiceStackProps extends cdk.StackProps {
  certificateArn?: string;
  lambdaZipPath: string;
}

export class PrivacyPolicyServiceStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: PrivacyPolicyServiceStackProps) {
    super(scope, id, props);

    if (!props.certificateArn) {
      throw new Error("PrivacyPolicyService needs -c certificateArn=<issued ACM certificate ARN from PrivacyPolicyCertificate>.");
    }

    const zipPath = path.resolve(props.lambdaZipPath);
    if (!existsSync(zipPath)) {
      throw new Error(`PrivacyPolicy Lambda archive is missing at ${zipPath}. Start Docker, run ../scripts/package-lambda.sh, then synthesize or deploy again.`);
    }

    const logGroup = new logs.LogGroup(this, "ApplicationLogGroup", {
      logGroupName: "/aws/lambda/privacy-policy",
      retention: logs.RetentionDays.ONE_WEEK,
      removalPolicy: cdk.RemovalPolicy.RETAIN,
    });

    const policyFunction = new lambda.Function(this, "PolicyFunction", {
      functionName: "privacy-policy",
      runtime: lambda.Runtime.PROVIDED_AL2023,
      handler: "bootstrap",
      architecture: lambda.Architecture.ARM_64,
      code: lambda.Code.fromAsset(zipPath),
      memorySize: 128,
      timeout: cdk.Duration.seconds(5),
      tracing: lambda.Tracing.DISABLED,
      logGroup,
      description: "Serves public app privacy policies for Gale W.",
    });

    const functionUrl = policyFunction.addFunctionUrl({
      authType: lambda.FunctionUrlAuthType.AWS_IAM,
      invokeMode: lambda.InvokeMode.BUFFERED,
    });

    const certificate = acm.Certificate.fromCertificateArn(this, "Certificate", props.certificateArn);
    const responseHeadersPolicy = new cloudfront.ResponseHeadersPolicy(this, "SecurityHeaders", {
      securityHeadersBehavior: {
        contentSecurityPolicy: {
          contentSecurityPolicy: "default-src 'none'; style-src 'unsafe-inline'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'",
          override: true,
        },
        contentTypeOptions: { override: true },
        frameOptions: { frameOption: cloudfront.HeadersFrameOption.DENY, override: true },
        referrerPolicy: { referrerPolicy: cloudfront.HeadersReferrerPolicy.NO_REFERRER, override: true },
        strictTransportSecurity: {
          accessControlMaxAge: cdk.Duration.days(365),
          includeSubdomains: true,
          override: true,
          preload: true,
        },
      },
    });

    const distribution = new cloudfront.Distribution(this, "Distribution", {
      domainNames: [domainName],
      certificate,
      enableLogging: false,
      enableIpv6: true,
      minimumProtocolVersion: cloudfront.SecurityPolicyProtocol.TLS_V1_2_2021,
      httpVersion: cloudfront.HttpVersion.HTTP2_AND_3,
      defaultBehavior: {
        origin: origins.FunctionUrlOrigin.withOriginAccessControl(functionUrl),
        allowedMethods: cloudfront.AllowedMethods.ALLOW_GET_HEAD_OPTIONS,
        cachedMethods: cloudfront.CachedMethods.CACHE_GET_HEAD_OPTIONS,
        cachePolicy: cloudfront.CachePolicy.CACHING_OPTIMIZED,
        viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
        responseHeadersPolicy,
      },
    });

    // Lambda Function URLs created after October 2025 require both actions.
    // FunctionUrlOrigin creates the InvokeFunctionUrl permission; this one
    // permits the signed CloudFront OAC request to invoke the function itself.
    policyFunction.addPermission("AllowCloudFrontInvokeFunction", {
      action: "lambda:InvokeFunction",
      principal: new iam.ServicePrincipal("cloudfront.amazonaws.com"),
      sourceArn: distribution.distributionArn,
      invokedViaFunctionUrl: true,
    });

    new cdk.CfnOutput(this, "PolicyUrl", { value: `https://${domainName}/` });
    new cdk.CfnOutput(this, "CloudFrontDomainName", { value: distribution.distributionDomainName });
    new cdk.CfnOutput(this, "CloudflareCname", {
      value: `${domainName} CNAME ${distribution.distributionDomainName}`,
      description: "Create this proxied-off CNAME in Cloudflare after the distribution is deployed.",
    });
  }
}
