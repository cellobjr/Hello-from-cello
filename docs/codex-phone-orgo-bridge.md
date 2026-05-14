# Codex Phone Orgo Bridge

Owner: Marcell
Technical operator: Justin
Status: wired in repo, requires Codex Cloud secret `ORGO_API_KEY`

## What This Does

This repo gives Codex Cloud a safe way to control Orgo Computer 2 when Marcell starts a task from the Codex app on his phone.

Without this bridge, Codex Cloud only sees the GitHub repo sandbox and may say it cannot control a computer. With this bridge plus the `ORGO_API_KEY` secret, Codex Cloud can call the Orgo API to inspect and operate Orgo Computer 2.

## Required Cloud Secret

Add this secret to the Codex Cloud environment for this repo:

```text
ORGO_API_KEY
```

Do not commit the value to GitHub. Do not paste it into task prompts.

## Smoke Test

From a Codex Cloud task in this repo, run:

```bash
./scripts/orgo.sh status
./scripts/orgo.sh screenshot
```

Expected result:

- `status` returns Orgo Computer 2 details with status `running`.
- `screenshot` writes a PNG under `artifacts/`.

## ManyChat Read-Only Prompt

Use this from the phone:

```text
Use Orgo Computer 2 through this repo's Orgo bridge.
Open ManyChat in the existing Orgo browser session and go to the metrics page.
Read-only only.
Do not enter passwords, OTP, MFA, CAPTCHA, send messages, change settings, publish flows, or mutate contacts.
Report: status, what metrics are visible, blocker, and next action.
```

## Guardrails

Read-only browser inspection is allowed when already logged in.

Ask Marcell before any live send, public post, paid spend, destructive delete, permission change, account/key creation, CRM/contact mutation, ManyChat contact/flow mutation, Shopify purchase or Set Live, MFA, OTP, CAPTCHA, or password entry.
