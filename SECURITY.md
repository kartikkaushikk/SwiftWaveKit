# Security Policy

## Supported Versions

WaveKit is pre-1.0 and under active development. Security fixes are applied to the latest released version only.

| Version | Supported |
|---|---|
| Latest (`master`) | ✅ |
| Older tagged releases | ❌ |

Once the project reaches 1.0, this table will be updated to reflect a proper support window across minor versions.

---

## Reporting a Vulnerability

**Please do not open a public GitHub issue for security vulnerabilities.** Public issues are visible to everyone immediately, including anyone who might exploit the report before a fix ships.

Instead, report privately using one of the following:

- **GitHub Private Security Advisory** (preferred): go to the [Security tab](../../security/advisories/new) of this repository and click "Report a vulnerability."
- **Email**: kartik14704@gmail.com — please include "WaveKit Security" in the subject line.

### What to Include

To help us triage quickly, please include:
- A description of the vulnerability and its potential impact
- Steps to reproduce, or a minimal code sample
- Affected version(s) / commit SHA
- Any suggested fix, if you have one (not required)

### What to Expect

- **Acknowledgment**: within 3–5 days of your report.
- **Status updates**: we'll keep you posted as we investigate and work on a fix.
- **Disclosure**: once a fix is released, we'll credit you in the release notes (unless you'd prefer to remain anonymous) and, where appropriate, publish a GitHub Security Advisory.

We ask that you give us reasonable time to address the issue before any public disclosure.

---

## Scope

WaveKit is a client-side rendering library (SwiftUI + SceneKit) with no network requests, no external dependencies, and no handling of user credentials or sensitive data by design. Relevant vulnerability classes here are narrower than in a typical backend project, but still worth reporting — for example:

- Crashes or undefined behavior triggerable via malformed input to public APIs (e.g. pathological `WaveFunction` closures, malformed `WaveConfiguration` values)
- Memory safety issues in SceneKit mesh/geometry generation
- Denial-of-service via unbounded resource usage (e.g. extreme `sampleCount` or grid `lineCount` values)

General bugs that don't have a security impact should go through the normal [issue tracker](../../issues) instead.

---

## Thank You

We appreciate the effort that goes into responsibly reporting vulnerabilities, and we'll do our best to respond promptly and keep you informed throughout the process.
