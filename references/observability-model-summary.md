# Observability Model Summary

Use this file when the private `platform-observability-model` repository is unavailable.

## Principles

- Observability starts from intent.
- OpenTelemetry semantic conventions are the baseline.
- Org semantic extensions must be explicit, low-cardinality by default, and enforceable.
- Alerts require immediate action and complete context.
- Notifications are useful but not urgent.
- Findings are policy or standards drift.
- Dashboards are incident decision surfaces, not manual overview loops.
- Backend resources are generated artifacts.

## Required Alert Context

Every page-worthy alert needs:

- identity: app, service, environment, namespace, workload, version, deployment
- ownership: team, routing key, escalation, criticality
- impact: capability, route/page/API/journey, affected traffic or users, SLO impact
- current state: value, threshold, duration, first detected, last healthy, trend
- change context: deployments, config, Helm values, policy, dependencies, CI runs
- evidence: traffic, errors, latency, saturation, readiness, events, logs, traces, RUM
- decision support: likely failure mode, recommended action, playbook, incident state
- dynamic dashboard: pre-scoped time window and variables

## Unified SLO Interface

SLO intent should define:

- target application and service
- user journey or capability
- SLI type and success condition
- objective and window
- evaluation basis
- telemetry binding
- burn-rate policy
- alert routing
- decision dashboard
- playbook action

Backend rules are generated from this interface.

