# Source Prompt

Use `$observability-engineering` to create a platform-agnostic observability intent packet for `checkout-api`.

Context:

- `checkout-api` runs in production and supports user checkout.
- Reliability work needs SLIs, SLOs, alert evidence, dashboard intent, and backend artifact requests.
- Candidate signals include RED metrics, dependency metrics, structured logs, traces, deploy events, and incident annotations.
- Runtime metadata must preserve service ownership, environment, version, deployment, route, status, trace correlation, and dependency identity.
- Telemetry collection and routing are not yet designed; hand off pipeline topology and delivery policy to `$creating-observability-pipelines`.
- SRE rules and backend-specific resources must be generated outputs, not handwritten intent.
- Include validation, rollback, and verification evidence.

Produce these artifacts:

- `ObservabilityIntent`
- `TelemetryContract`
- `SloIntent`
- `AlertContextContract`
- `DecisionDashboardPlan`
- `BackendArtifactManifest`
- `PipelineHandoff`
- `VerificationEvidence`
