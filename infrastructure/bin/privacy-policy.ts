#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import * as path from "node:path";
import {
  PrivacyPolicyCertificateStack,
  PrivacyPolicyDeploymentStack,
  PrivacyPolicyServiceStack,
} from "../lib/privacy-policy-stack.js";

const app = new cdk.App();
const account = app.node.tryGetContext("account") ?? process.env.CDK_DEFAULT_ACCOUNT;
const serviceRegion = app.node.tryGetContext("serviceRegion") ?? "us-east-2";
const certificateArn = app.node.tryGetContext("certificateArn");
const lambdaZipPath = path.resolve(
  process.cwd(),
  app.node.tryGetContext("lambdaZipPath") ?? "../.build/plugins/AWSLambdaPackager/outputs/AWSLambdaPackager/App/App.zip",
);

if (!account) {
  throw new Error("PrivacyPolicy infrastructure needs an AWS account. Run through the signed-in AWS CLI or pass -c account=<account-id>.");
}

new PrivacyPolicyCertificateStack(app, "PrivacyPolicyCertificate", {
  env: { account, region: "us-east-1" },
});

new PrivacyPolicyDeploymentStack(app, "PrivacyPolicyDeployment", {
  env: { account, region: serviceRegion },
  serviceRegion,
});

if (certificateArn) {
  new PrivacyPolicyServiceStack(app, "PrivacyPolicyService", {
    env: { account, region: serviceRegion },
    certificateArn,
    lambdaZipPath,
  });
} else {
  console.warn("PrivacyPolicyService is intentionally omitted until an issued certificate ARN is supplied with -c certificateArn=<arn>.");
}
