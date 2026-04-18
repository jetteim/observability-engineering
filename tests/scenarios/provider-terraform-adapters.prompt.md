# Source Prompt

Use `$observability-engineering` to generate provider-specific Terraform adapters for the `checkout-api` observability and reliability packet.

Context:

- Neutral source artifacts already exist: `ObservabilityIntent`, `SloIntent`, `AlertContextContract`, `DecisionDashboardPlan`, and reliability evidence from `$reliability-engineering`.
- Provider targets are Datadog and the Elastic ecosystem.
- Datadog should generate Terraform resources for SLOs, monitors, dashboards, service ownership metadata, and validation commands.
- Elastic should generate Terraform for supported Elastic Stack/Kibana resources and explicitly report provider/API gaps instead of inventing resources.
- Do not embed secrets in generated Terraform.
- Treat provider resources as generated outputs from neutral intent.
- Capture target, blast radius, rollback path, and verification evidence.

Produce these artifacts:

- `ProviderTerraformAdapterManifest`
- `DatadogTerraformAdapter`
- `ElasticTerraformAdapter`
- `GeneratedTerraformFiles`
- `ProviderValidationPlan`
- `ProviderGenerationEvidence`
