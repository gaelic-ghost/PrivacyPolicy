import assert from "node:assert/strict";
import { mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import test from "node:test";
import * as cdk from "aws-cdk-lib";
import { Template } from "aws-cdk-lib/assertions";
import { PrivacyPolicyDeploymentStack, PrivacyPolicyServiceStack } from "../lib/privacy-policy-stack.js";

const githubProductionOIDCSubject =
  "repo:gaelic-ghost@236288055/PrivacyPolicy@1312371347:environment:production";

test("uses one immutable GitHub production identity for deployment", () => {
  const app = new cdk.App();
  const stack = new PrivacyPolicyDeploymentStack(app, "PrivacyPolicyDeployment", {
    env: { account: "698361935030", region: "us-east-2" },
    serviceRegion: "us-east-2",
  });
  const template = Template.fromStack(stack);

  template.hasResourceProperties("AWS::IAM::Role", {
    RoleName: "privacy-policy-github-actions-deploy-v2",
    AssumeRolePolicyDocument: {
      Statement: [{
        Action: "sts:AssumeRoleWithWebIdentity",
        Condition: {
          StringEquals: {
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub": githubProductionOIDCSubject,
          },
        },
        Effect: "Allow",
      }],
    },
  });

  const roles = template.findResources("AWS::IAM::Role");
  const roleNames = Object.values(roles)
    .map((role) => role.Properties?.RoleName)
    .filter((roleName): roleName is string => typeof roleName === "string");
  assert.deepEqual(roleNames, ["privacy-policy-github-actions-deploy-v2"]);
});

test("configures Lambda for the x86-64 archive produced by package-lambda", () => {
  const archiveDirectory = mkdtempSync(join(tmpdir(), "privacy-policy-lambda-"));
  const archivePath = join(archiveDirectory, "App.zip");
  writeFileSync(archivePath, "test archive placeholder");

  try {
    const app = new cdk.App();
    const stack = new PrivacyPolicyServiceStack(app, "PrivacyPolicyService", {
      env: { account: "698361935030", region: "us-east-2" },
      certificateArn: "arn:aws:acm:us-east-1:698361935030:certificate/test-certificate",
      lambdaZipPath: archivePath,
    });

    Template.fromStack(stack).hasResourceProperties("AWS::Lambda::Function", {
      Architectures: ["x86_64"],
    });
  } finally {
    rmSync(archiveDirectory, { recursive: true, force: true });
  }
});
