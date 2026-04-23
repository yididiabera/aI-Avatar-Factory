# Canonical Atom Structures

This document defines the canonical MeTTa atom shapes for the three core
Avatar Video Factory records we need consistent access to:

- `Brand`
- `Script`
- `MediaAsset`

These structures are aligned to the paper's explicit examples and are intended
to be the single source of truth for how these atoms are represented.

---

## Brand

### Canonical form

```metta
(Brand id
  (voice text)
  (audience
    (primary text)
    (secondary text))
  (visual-identity
    (colors color...)
    (style text))
  (competitors (competitor-id...))
  (content-pillars (pillar...)))
```

### Field meaning

| Field | Meaning |
|-------|---------|
| `id` | Stable brand identifier |
| `(voice ...)` | Brand voice and writing guidance |
| `(audience ...)` | Primary and secondary audience segments |
| `(visual-identity ...)` | Visual direction and brand colors |
| `(competitors ...)` | Relevant comparison brands |
| `(content-pillars ...)` | Reusable content themes |

### Example

```metta
(Brand "acme-saas"
  (voice "Professional but approachable. No jargon. Short sentences.")
  (audience
    (primary "B2B SaaS buyers 30-45")
    (secondary "developers"))
  (visual-identity
    (colors "#2563EB" "#1E40AF")
    (style "clean, modern"))
  (competitors ("competitor-x" "competitor-y"))
  (content-pillars ("product demos" "customer stories" "industry insights")))
```

### Structural checks

- `Brand` always starts with a single stable `id`
- nested properties are named, so access does not depend on fragile field order
- list-like values remain grouped under a semantic parent node

---

## Script

### Canonical form

```metta
(Script id
  (brief brief-id)
  (hook text)
  (body text)
  (cta text)
  (overlays (overlay...))
  (target-duration-sec n)
  (voice-style text))
```

### Field meaning

| Field | Meaning |
|-------|---------|
| `id` | Stable script identifier |
| `(brief ...)` | Source brief for the script |
| `(hook ...)` | Opening line or first-beat hook |
| `(body ...)` | Main explanatory or persuasive content |
| `(cta ...)` | Closing call to action |
| `(overlays ...)` | On-screen text items |
| `(target-duration-sec ...)` | Planned runtime |
| `(voice-style ...)` | Delivery tone |

### Example

```metta
(Script "script-042-hookB"
  (brief "brief-campaign42-v3")
  (hook "What if I told you your SaaS onboarding is losing you 40% of signups?")
  (body "Here are the three friction points...")
  (cta "Link in bio for the full teardown")
  (overlays ("40% drop-off" "3 friction points" "link in bio"))
  (target-duration-sec 45)
  (voice-style "energetic, conversational"))
```

### Structural checks

- `Script` links cleanly back to exactly one brief through `(brief ...)`
- each major content section is explicitly named
- overlays are grouped as one list-valued property instead of flattened text

---

## MediaAsset

### Canonical form

```metta
(MediaAsset id
  (type mime-type)
  (created iso-8601)
  (creator skill-or-stage)
  (params
    (voice voice-id)
    (avatar avatar-id)
    (format aspect-ratio))
  (quality-score n)
  (parent-brief brief-id)
  (parent-script script-id)
  (file-path abs-path)
  (file-size bytes))
```

### Field meaning

| Field | Meaning |
|-------|---------|
| `id` | Stable asset identifier |
| `(type ...)` | Media MIME type |
| `(created ...)` | Creation timestamp |
| `(creator ...)` | Producing skill or pipeline stage |
| `(params ...)` | Production parameters used to generate the asset |
| `(quality-score ...)` | Aggregate quality score |
| `(parent-brief ...)` | Upstream brief lineage |
| `(parent-script ...)` | Upstream script lineage |
| `(file-path ...)` | Concrete asset location |
| `(file-size ...)` | Size in bytes |

### Example

```metta
(MediaAsset "asset-v001"
  (type "video/mp4")
  (created "2026-03-22T18:00:00Z")
  (creator "production-pipeline")
  (params
    (voice "ElevenLabs-Rachel")
    (avatar "HeyGen-01")
    (format "9:16"))
  (quality-score 0.87)
  (parent-brief "brief-campaign42-v3")
  (parent-script "script-042-hookB")
  (file-path "/home/mettaclaw/assets/v001.mp4")
  (file-size 14200000))
```

### Structural checks

- `MediaAsset` preserves lineage to both brief and script
- generation parameters are grouped under `(params ...)`
- operational metadata like file path and file size remain distinct from lineage

---

## Consistency Rules

To keep storage and retrieval consistent, these three atoms should follow the
same design rules:

- first position after the atom name is always the stable identifier
- descriptive fields use named nested properties
- grouped values stay grouped rather than being flattened into positional slots
- lineage fields use explicit names like `brief`, `parent-brief`, and `parent-script`