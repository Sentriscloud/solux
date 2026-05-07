# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this repository, please report it privately. **Do not open a public GitHub issue.**

**Contact:** `security@sentriscloud.com`

Please include:

- A description of the vulnerability
- Steps to reproduce
- The affected version / commit hash
- Any suggested mitigation

## Response Timeline

- **Initial acknowledgment:** within 72 hours
- **Triage:** within 7 days
- **Resolution target:** depends on severity (critical: days, high: weeks, medium: next release)

## Scope

This repository is currently a **UI prototype** — no key generation, signing, or chain integration is implemented. Any "wallet" path in the app is a non-functional placeholder.

Reports about UI/UX, build pipelines, and dependency vulnerabilities are still in scope. Reports about key handling / signing / sending funds are not applicable until the crypto layer lands (see README).

In scope when crypto layer lands:

- Key generation, storage, signing
- Transaction construction + RPC integration
- Mnemonic / seed handling
- Build configs (release signing, ProGuard / R8)

Out of scope:

- Third-party dependencies (report upstream first; we can advisory-track if confirmed)
- Issues requiring physical access to a validator host
- Social engineering against operators

## Bug Bounty

A formal bug bounty program is under design. Reach out for case-by-case disclosure rewards.
