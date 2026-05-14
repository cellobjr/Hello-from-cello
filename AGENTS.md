# Codex Cloud Orgo Bridge Instructions

Owner: Marcell
Technical operator: Justin
Primary fallback computer: Orgo Computer 2

## Purpose

This repository is the phone fallback command lane for Codex Cloud. When Marcell starts a task from the Codex app on his phone and asks for browser/computer work, Codex Cloud must use the Orgo bridge in this repo instead of claiming it cannot control a computer.

## Orgo Computer 2

- Computer name: Computer 2
- Computer ID: `da19c9f7-ff59-452e-b66b-9f5abb73b9a0`
- Intended lane: Codex phone fallback, authenticated browser work, safe read-only checks, and secondary CLOUT Crown browser tasks.
- Required secret: `ORGO_API_KEY` must exist in the Codex Cloud environment.
- Optional override: `ORGO_COMPUTER_ID` can override the default computer ID, but should normally stay unset.

## Required Behavior

When a task asks to use a computer, Orgo, a browser, ManyChat, Shopify, authenticated web access, or remote desktop control:

1. Check whether `ORGO_API_KEY` is available.
2. Run `bash scripts/orgo.sh status` to confirm Orgo Computer 2 is running.
3. Run `bash scripts/orgo.sh screenshot` to see the current screen.
4. Use `bash scripts/orgo.sh bash`, `click`, `type`, and `key` only as needed.
5. Report proof, blocker, and next action.

## Approval Gates

Do not enter passwords, OTP, MFA, CAPTCHA, or security-key flows. Ask Marcell.

Do not send outbound messages, mutate CRM/contact records, change permissions, create keys/accounts, spend money, publish, set live, delete destructively, or change production settings without Marcell approval.

For ManyChat specifically: read-only metrics inspection is allowed. Editing automations, sending messages, changing contacts, changing integrations, or publishing flows requires explicit Marcell approval.

## If The Bridge Is Missing

If `ORGO_API_KEY` is missing, say this exactly:

`Blocker: Codex Cloud does not have ORGO_API_KEY in its environment yet. Add the Orgo API key as a Codex Cloud secret named ORGO_API_KEY, then rerun this task.`

Do not say Codex cannot control a computer until after checking this repo's Orgo bridge.
