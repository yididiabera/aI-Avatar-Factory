# MeTTa vs Python — Implementation Boundary

## The Boundary in One Sentence

> Python drives the pipeline. MeTTa holds the knowledge and rules.
> MeTTaClaw is called when memory or reasoning is needed.

---

## Use MeTTa for

| What                                                         | Why                                                         |
| ------------------------------------------------------------ | ----------------------------------------------------------- |
| Atom schema definitions (`Brand`, `Script`, `MediaAsset`)    | Must live in AtomSpace so MeTTaClaw can reason over them    |
| Queries against AtomSpace                                    | MeTTa's native pattern matching is the right retrieval tool |
| Rules and invariants (e.g. "never publish without approval") | Declarative logic is what MeTTa is built for                |

---

## Use Python for Everything Else

| What                                              | Why                                   |
| ------------------------------------------------- | ------------------------------------- |
| API calls (HeyGen, ElevenLabs, TikTok, etc.)      | HTTP clients, SDKs, auth — all Python |
| File I/O (reading/writing media assets)           | Standard Python                       |
| FFmpeg orchestration (video composition)          | Subprocess calls                      |
| Business logic (pipeline steps, state machine)    | Easier to test, debug, and maintain   |
| Scheduling, queues, approval workflow             | Python has mature libraries           |
| Analytics data processing                         | Pandas, etc.                          |
| Talking to MeTTaClaw's channel (IRC send/receive) | Already Python in the MeTTaClaw repo  |

---

## Integration Model

MeTTaClaw is used as a **tool**, not extended.

- We do **not** add skills into `src/skills.metta`.
- We do **not** modify the MeTTaClaw loop.
- Our atoms live in **our own space**, not MeTTaClaw's `&self`.
- When the pipeline needs reasoning, memory, or web search, it sends a command
  to MeTTaClaw (e.g. `remember`, `query`, `shell`) and reads the result back.

```
Python pipeline
     │
     │  mettaclaw_send("(remember \"...atom...\")")
     ▼
MeTTaClaw (IRC channel)
     │
     │  evaluates in MeTTa → writes to ChromaDB
     ▼
AtomSpace (ChromaDB backend)
```
