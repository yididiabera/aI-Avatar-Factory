# Avatar Video Factory — AtomSpace Schema

## What This Document Covers

Every atom type used by the Avatar Video Factory, organized by skill. For each
atom: its S-expression structure, field definitions, an example, and which skill
reads or writes it.

All atoms are stored in a dedicated `&avatar` space, separate from MeTTaClaw's `&self`.

---

## Atom types overview

| Atom               | Owned by skill | Role                                         |
| ------------------ | -------------- | -------------------------------------------- |
| `Brand`            | A1             | Client identity, voice, audience, guidelines |
| `VoiceProfile`     | A6 onboarding  | Named voice configuration used by A4         |
| `AvatarProfile`    | A6 onboarding  | Named talking-head configuration used by A4  |
| `Campaign`         | A2             | Time-boxed marketing goal for a brand        |
| `Brief`            | A2             | Single-video creative spec                   |
| `Script`           | A3             | Hook / body / CTA / overlays for one video   |
| `MediaAsset`       | S1 / A4        | Any generated or sourced file                |
| `ApiAuditLog`      | S2             | Record of every external API call            |
| `QAReport`         | S3             | Quality assessment result for an asset       |
| `PublishRecord`    | A5             | Record of a publish event on a platform      |
| `VideoPerformance` | A5             | Platform analytics for a published asset     |
| `ApprovalRecord`   | A6             | Approval / revision / rejection decision     |

---

## Brand

_Skill A1 — Brand Knowledge Manager_

```
(Brand id voice audience visual competitors pillars)
```

| Field         | Type                                | Description                    |
| ------------- | ----------------------------------- | ------------------------------ |
| `id`          | String                              | Unique key, e.g. `"acme-saas"` |
| `voice`       | String                              | Brand voice guideline          |
| `audience`    | `(BrandAudience primary secondary)` | Primary and secondary audience |
| `visual`      | `(BrandVisual colors style)`        | Color palette and visual style |
| `competitors` | List of String                      | Competitor ids                 |
| `pillars`     | List of String                      | Content pillar categories      |

Sub-atoms:

- `(BrandAudience primary secondary)` — both fields String
- `(BrandVisual colors style)` — both fields String

Example:

```
(Brand "acme-saas"
  "Professional but approachable. No jargon."
  (BrandAudience "B2B SaaS buyers 30-45" "developers")
  (BrandVisual "#2563EB #1E40AF" "clean modern")
  ("competitor-x" "competitor-y")
  ("product demos" "customer stories" "industry insights"))
```

---

## VoiceProfile

_Skill A6 — Client Workflow (onboarding) / used by A4_

```
(VoiceProfile id brand-id provider voice-name settings)
```

| Field        | Type                                         | Description                                 |
| ------------ | -------------------------------------------- | ------------------------------------------- |
| `id`         | String                                       | Unique key, e.g. `"voice-rachel"`           |
| `brand-id`   | String                                       | References a `Brand` id                     |
| `provider`   | String                                       | e.g. `"ElevenLabs"` `"XTTS"` `"OpenAI-TTS"` |
| `voice-name` | String                                       | Provider-specific voice identifier          |
| `settings`   | `(VoiceSettings stability similarity style)` | Tunable voice parameters                    |

Sub-atom:

- `(VoiceSettings stability similarity style)` — all fields Number (0.0–1.0)

Example:

```
(VoiceProfile "voice-rachel"
  "acme-saas"
  "ElevenLabs"
  "Rachel"
  (VoiceSettings 0.75 0.85 0.0))
```

---

## AvatarProfile

_Skill A6 — Client Workflow (onboarding) / used by A4_

```
(AvatarProfile id brand-id provider avatar-name appearance)
```

| Field         | Type   | Description                                 |
| ------------- | ------ | ------------------------------------------- |
| `id`          | String | Unique key, e.g. `"avatar-heygen-01"`       |
| `brand-id`    | String | References a `Brand` id                     |
| `provider`    | String | e.g. `"HeyGen"` `"Synthesia"` `"SadTalker"` |
| `avatar-name` | String | Provider-specific avatar identifier         |
| `appearance`  | String | Short description of the avatar persona     |

Example:

```
(AvatarProfile "avatar-heygen-01"
  "acme-saas"
  "HeyGen"
  "HeyGen-01"
  "business-casual male, 30s, neutral background")
```

---

## Campaign

_Skill A2 — Campaign & Creative Strategy_

```
(Campaign id brand-id objective duration-days status expected-score)
```

| Field            | Type   | Description                                    |
| ---------------- | ------ | ---------------------------------------------- |
| `id`             | String | Unique key, e.g. `"camp-001"`                  |
| `brand-id`       | String | References a `Brand` id                        |
| `objective`      | String | Goal description                               |
| `duration-days`  | Number | Campaign length in days                        |
| `status`         | String | One of: `"draft"` `"active"` `"complete"`      |
| `expected-score` | Number | Float 0.0–1.0, A2's predicted performance rank |

Example:

```
(Campaign "camp-001" "acme-saas" "Grow Q2 signups" 30 "active" 0.72)
```

---

## Brief

_Skill A2 — Campaign & Creative Strategy_

```
(Brief id campaign-id topic angle hook-approach target-emotion cta-type visual-style production-requirements)
```

| Field                     | Type   | Description                                                          |
| ------------------------- | ------ | -------------------------------------------------------------------- |
| `id`                      | String | Unique key, e.g. `"brief-001"`                                       |
| `campaign-id`             | String | References a `Campaign` id                                           |
| `topic`                   | String | Subject of the video                                                 |
| `angle`                   | String | Creative approach                                                    |
| `hook-approach`           | String | One of: `"question"` `"statement"` `"stat"` `"story"`                |
| `target-emotion`          | String | Intended viewer emotional response                                   |
| `cta-type`                | String | Call-to-action category, e.g. `"link-in-bio"`                        |
| `visual-style`            | String | Visual direction, e.g. `"clean, text-heavy"`                         |
| `production-requirements` | String | Estimated production needs, e.g. `"voice + avatar + 2 b-roll clips"` |

Example:

```
(Brief "brief-001" "camp-001"
  "SaaS onboarding drop-off"
  "pain-point reveal"
  "question"
  "urgency"
  "link-in-bio"
  "clean, text-heavy overlays"
  "voice + avatar + 2 b-roll clips")
```

---

## Script

_Skill A3 — Script Generation_

```
(Script id brief-id hook body cta overlays timing-marks duration-sec voice-style)
```

| Field          | Type           | Description                            |
| -------------- | -------------- | -------------------------------------- |
| `id`           | String         | Unique key, e.g. `"scr-001"`           |
| `brief-id`     | String         | References a `Brief` id                |
| `hook`         | String         | First 3-second opening line            |
| `body`         | String         | Value-delivery content                 |
| `cta`          | String         | Closing call-to-action                 |
| `overlays`     | List of String | On-screen text items                   |
| `timing-marks` | List of Number | Second offsets aligned to each overlay |
| `duration-sec` | Number         | Estimated duration in seconds          |
| `voice-style`  | String         | Delivery tone description              |

Example:

```
(Script "scr-001" "brief-001"
  "What if your onboarding is losing 40% of signups?"
  "Here are the three friction points..."
  "Link in bio for the full teardown"
  ("40% drop-off" "3 friction points" "link in bio")
  (0 8 40)
  45
  "energetic conversational")
```

---

## MediaAsset

_Skill S1 — Media Asset Management / A4 — Video Production Pipeline_

```
(MediaAsset id type created creator params quality-score parent-brief parent-script file-path file-size)
```

| Field           | Type                                | Description                                          |
| --------------- | ----------------------------------- | ---------------------------------------------------- |
| `id`            | String                              | Unique content-addressed key                         |
| `type`          | String                              | MIME type: `"video/mp4"` `"audio/wav"` `"image/png"` |
| `created`       | String                              | ISO-8601 timestamp                                   |
| `creator`       | String                              | Skill or stage that produced it                      |
| `params`        | `(AssetParams voice avatar format)` | Production parameters                                |
| `quality-score` | Number                              | Float 0.0–1.0 from QA gate                           |
| `parent-brief`  | String                              | References a `Brief` id (lineage)                    |
| `parent-script` | String                              | References a `Script` id (lineage)                   |
| `file-path`     | String                              | Absolute container path                              |
| `file-size`     | Number                              | Integer bytes                                        |

Sub-atom:

- `(AssetParams voice avatar format)` — `voice` references a `VoiceProfile` id, `avatar` references an `AvatarProfile` id, `format` is a String like `"9:16"` or `"16:9"`

Example:

```
(MediaAsset "asset-v001"
  "video/mp4"
  "2026-04-20T09:00:00Z"
  "produce-full"
  (AssetParams "voice-rachel" "avatar-heygen-01" "9:16")
  0.87
  "brief-001"
  "scr-001"
  "/home/mettaclaw/assets/v001.mp4"
  14200000)
```

---

## ApiAuditLog

_Skill S2 — Media Generation API Gateway_

```
(ApiAuditLog id skill provider capability endpoint params status cost-usd latency-ms timestamp)
```

| Field        | Type   | Description                                    |
| ------------ | ------ | ---------------------------------------------- |
| `id`         | String | Unique log entry key                           |
| `skill`      | String | Skill that triggered the call                  |
| `provider`   | String | e.g. `"ElevenLabs"` `"HeyGen"` `"RunPod"`      |
| `capability` | String | e.g. `"voice-synthesis"` `"avatar-generation"` |
| `endpoint`   | String | Full URL or API path called                    |
| `params`     | String | Serialized request params (JSON string)        |
| `status`     | String | One of: `"success"` `"failure"` `"retry"`      |
| `cost-usd`   | Number | Float cost of this call                        |
| `latency-ms` | Number | Integer milliseconds                           |
| `timestamp`  | String | ISO-8601 timestamp                             |

Example:

```
(ApiAuditLog "log-001"
  "produce-voice"
  "ElevenLabs"
  "voice-synthesis"
  "https://api.elevenlabs.io/v1/text-to-speech/Rachel"
  "{\"text\":\"...\",\"model\":\"eleven_multilingual_v2\"}"
  "success"
  0.012
  1340
  "2026-04-20T09:01:00Z")
```

---

## QAReport

_Skill S3 — Quality Assessment_

```
(QAReport id asset-id type overall-pass overall-score checks)
```

| Field           | Type                                      | Description                            |
| --------------- | ----------------------------------------- | -------------------------------------- |
| `id`            | String                                    | Unique report key                      |
| `asset-id`      | String                                    | References a `MediaAsset` id           |
| `type`          | String                                    | One of: `"video"` `"audio"` `"script"` |
| `overall-pass`  | String                                    | `"pass"` or `"fail"`                   |
| `overall-score` | Number                                    | Float 0.0–1.0                          |
| `checks`        | `(QAChecks (criterion pass-or-fail) ...)` | Named criterion results                |

Criterion names by type (from paper):

- **video:** `resolution`, `audio-sync`, `lip-sync`, `frame-consistency`, `subtitle-readability`, `duration`
- **audio:** `lufs`, `silence`, `pronunciation`, `noise-level`
- **script:** `length`, `hook-present`, `cta-present`, `brand-voice-match`

Example:

```
(QAReport "qa-001"
  "asset-v001"
  "video"
  "pass"
  0.91
  (QAChecks
    (resolution "pass")
    (audio-sync "pass")
    (lip-sync "fail")
    (frame-consistency "pass")
    (subtitle-readability "pass")
    (duration "pass")))
```

---

## PublishRecord

_Skill A5 — Distribution & Analytics_

```
(PublishRecord id asset-id platform platform-post-id scheduled-time published-time status)
```

| Field              | Type   | Description                                       |
| ------------------ | ------ | ------------------------------------------------- |
| `id`               | String | Unique record key                                 |
| `asset-id`         | String | References a `MediaAsset` id                      |
| `platform`         | String | `"tiktok"` `"youtube-shorts"` `"instagram-reels"` |
| `platform-post-id` | String | Id returned by the platform API                   |
| `scheduled-time`   | String | ISO-8601 timestamp requested                      |
| `published-time`   | String | ISO-8601 timestamp actual (empty if pending)      |
| `status`           | String | One of: `"scheduled"` `"published"` `"failed"`    |

Example:

```
(PublishRecord "pub-001"
  "asset-v001"
  "tiktok"
  "7392841029384"
  "2026-04-20T18:00:00Z"
  "2026-04-20T18:00:03Z"
  "published")
```

---

## VideoPerformance

_Skill A5 — Distribution & Analytics_

```
(VideoPerformance id asset-id platform period views likes shares comments completion-rate click-through)
```

| Field             | Type   | Description                                        |
| ----------------- | ------ | -------------------------------------------------- |
| `id`              | String | Unique key, e.g. `"perf-v001-7d"`                  |
| `asset-id`        | String | References a `MediaAsset` id                       |
| `platform`        | String | `"tiktok"` `"youtube-shorts"` `"instagram-reels"`  |
| `period`          | String | Measurement window: `"24h"` `"48h"` `"7d"` `"30d"` |
| `views`           | Number | Integer                                            |
| `likes`           | Number | Integer                                            |
| `shares`          | Number | Integer                                            |
| `comments`        | Number | Integer                                            |
| `completion-rate` | Number | Float 0.0–1.0                                      |
| `click-through`   | Number | Float 0.0–1.0                                      |

Example:

```
(VideoPerformance "perf-v001-7d"
  "asset-v001"
  "tiktok"
  "7d"
  42000
  3200
  410
  185
  0.63
  0.04)
```

---

## ApprovalRecord

_Skill A6 — Client Workflow_

```
(ApprovalRecord id asset-id decision reviewer notes timestamp)
```

| Field       | Type   | Description                                                  |
| ----------- | ------ | ------------------------------------------------------------ |
| `id`        | String | Unique record key                                            |
| `asset-id`  | String | References a `MediaAsset` id                                 |
| `decision`  | String | One of: `"approved"` `"revision"` `"rejected"`               |
| `reviewer`  | String | Reviewer id or name                                          |
| `notes`     | String | Feedback for revision / rejection (empty string if approved) |
| `timestamp` | String | ISO-8601 timestamp — stored immutably                        |

Example:

```
(ApprovalRecord "appr-001"
  "asset-v001"
  "approved"
  "client-jedidiah"
  ""
  "2026-04-20T10:00:00Z")
```

---

## Lineage chain

```
Brand
  ├── VoiceProfile
  ├── AvatarProfile
  └── Campaign
        └── Brief
              └── Script
                    └── MediaAsset ──→ QAReport
                          │
                          ├──→ ApprovalRecord
                          └──→ PublishRecord ──→ VideoPerformance

ApiAuditLog  ──→  links to any skill call (no parent atom, append-only)
```

Every `MediaAsset` carries both `parent-brief` and `parent-script` so the full production chain is traceable from any single asset without re-querying intermediate atoms.  
`ApprovalRecord`, `PublishRecord`, and `ApiAuditLog` are append-only — never updated in place.

---

## Hard invariants (from paper)

- No `MediaAsset` may have a `PublishRecord` unless a matching `ApprovalRecord` with `decision = "approved"` exists.
- `ApprovalRecord` timestamps are never modified after writing.
- `ApiAuditLog` entries are append-only.
- `VideoPerformance` values are pulled from platform APIs and never manually edited.
- `PublishRecord` is append-only — retries create new records, not edits.
