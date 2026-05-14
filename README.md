# Hello from Cello

Fallback command repository for Codex Cloud connectivity and Orgo Computer 2 control.

Owner: Marcell
Technical operator: Justin
Purpose: Let Codex Cloud tasks started from the phone use a safe Orgo bridge instead of stopping at repo-only sandbox access.

## Codex Phone Fallback

Use this repo from the Codex app on your phone when Hermes/Discord is down or when you need Codex Cloud to dispatch browser/computer work through Orgo Computer 2.

Required cloud secret:

```text
ORGO_API_KEY
```

Do not commit the key. Store it only as a Codex Cloud environment secret.

## Quick Test

```bash
./scripts/orgo.sh status
./scripts/orgo.sh screenshot
```

If the key is missing, the bridge will report the exact blocker and next action.

## Main Files

- `AGENTS.md` — Codex Cloud operating instructions and guardrails.
- `scripts/orgo.sh` — Orgo Computer 2 API bridge.
- `docs/codex-phone-orgo-bridge.md` — phone prompt and smoke-test instructions.
