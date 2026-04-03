## Part 1: Spec-Driven Development (SDD)
### What Is It?
Spec-Driven Development is a development paradigm in which well-crafted software requirement specifications serve as the primary artifact — not the code. Rather than treating specs as passive documentation that guides developers, in SDD the specifications become executable sources that directly generate working implementations through AI coding agents.
The core conceptual inversion is: **"Specifications don't serve code — code serves specifications."** Historically, code was the truth and specs were scaffolding that got abandoned. SDD eliminates that gap by making specifications precise enough to generate working systems directly.
The term gained significant traction in 2025, driven by the rise of "vibe coding" (a term coined by Andrej Karpathy on February 2, 2025) and the explosion of AI code generation. With 25% of Y Combinator's Winter 2025 cohort having codebases that are 95% AI-generated, the need for structured methodologies to govern AI-assisted development became urgent.
---
### How It Differs from TDD and BDD
| Methodology | Primary Artifact | Driver | When It Runs |
|---|---|---|---|
| **TDD** | Tests | Tests drive implementation — write a failing test, then write code to pass it | Before and alongside code |
| **BDD** | Behavior scenarios | Collaboration tools written in Gherkin (Given/When/Then) that describe behavior | Before code, as shared team language |
| **SDD** | Specifications | Structured markdown specs that AI agents translate into code | Before code, as the complete system blueprint |
TDD uses tests to drive implementation. SDD separates planning from coding entirely by formalizing all requirements into structured specifications first, then generating code from those specs. BDD uses specs as team collaboration tools; SDD builds on that but adds technical constraints and structured formats optimized specifically for AI code generation. SDD can incorporate TDD and BDD concepts within it — for example, the `spec-kit` constitution mandates test-first ordering.
---
### Core Principles
1. **Specifications as Lingua Franca**: The spec becomes the single source of truth; code is merely its language-specific expression.
2. **Executable Specifications**: Specs must be "precise, complete, and unambiguous enough to generate working systems" directly.
3. **Intent-First**: Development focuses on expressing what needs to happen and why, not how.
4. **Continuous Refinement**: Validation happens continuously through AI analysis of specs for gaps, contradictions, and ambiguities — not as one-time gates.
5. **Research-Driven Context**: Research agents gather technical context (library compatibility, performance implications, organizational constraints) before planning.
6. **Bidirectional Feedback**: Production metrics and incidents inform specification evolution, not just triggering hotfixes.
7. **Anti-Speculation**: Specs explicitly forbid "might need" or speculative features. Only what is verified and needed is included.
---
### Three Implementation Levels
- **Spec-first**: A well-thought-out spec is written first and used in AI-assisted development for the task at hand. The spec may not be kept afterward.
- **Spec-anchored**: The spec is maintained even after the task is complete and continues to be used for evolution and maintenance of the feature.
- **Spec-as-source**: The spec is the primary artifact. Humans only ever edit the spec; the code is entirely AI-generated and regenerated. Files may be marked `// GENERATED FROM SPEC - DO NOT EDIT`.
---
### Workflow
1. **Capturing Intent**: Business goals, user requirements, functional expectations, and domain rules are captured in a structured, machine-readable manner.
2. **Constitution / Principles**: Non-negotiable project-level architectural principles are established (see `constitution.md` below).
3. **Specification**: The "what" and "why" are formalized into a spec document. Ambiguities are flagged with `[NEEDS CLARIFICATION]` markers rather than guessed.
4. **Clarification** (optional): Ambiguous areas are resolved through structured dialogue before technical planning begins.
5. **Planning**: Abstract intent is converted into concrete technical architecture — tech stack, data models, API contracts, test scenarios.
6. **Task Breakdown**: The plan is divided into executable units with parallelization markers where tasks are independent.
7. **Implementation**: AI agents execute all tasks according to the plan, with the spec as the governing document.
8. **Feedback Integration**: Production metrics and operational learnings flow back into specifications for systematic regeneration.
---
### Benefits
- **Early alignment**: Surfaces assumptions when changing direction costs keystrokes instead of sprints.
- **Living documentation**: Specs evolve alongside code, serving as active tools rather than abandoned artifacts.
- **Standardization**: The methodology is embedded in the specifications and workflow, not dependent on each developer's prompting skill.
- **Multi-variant implementations**: Because specs are detached from code, multiple implementations (e.g., Rust vs. Go) can be generated from the same spec.
- **Architectural determinism**: Reduced systemic drift and cross-language parity.
- **Reduced rework**: Clear specifications prevent misaligned assumptions early.
---
### Challenges
- Code generation from spec to LLM is non-deterministic, complicating upgrades and maintenance.
- Spec drift and hallucination are inherent risks, requiring robust CI/CD practices.
- No community consensus yet on what a "good spec" looks like or how to evaluate specs systematically.
- Can feel like "workflow overkill" for small tasks.
- Difficulty cleanly separating functional from technical requirements.
---
## Part 2: GitHub spec-kit
### What Is It?
`spec-kit` is GitHub's open-source toolkit that implements Spec-Driven Development. It is distributed as a Python-based CLI called `specify` and provides structured slash commands, templates, and scripts that guide AI coding agents through the full SDD workflow.
Repository: [https://github.com/github/spec-kit](https://github.com/github/spec-kit)
The core philosophy: "An open source toolkit that allows you to focus on product scenarios and predictable outcomes."
---
### The `specify` CLI
The `specify` CLI bootstraps SDD scaffolding for a project. It creates two key directories:
- `.github/` — Contains agent-specific prompt files for the chosen AI tool (Copilot, Claude Code, Gemini CLI, Cursor, Windsurf, etc.)
- `.specify/` — Contains core SDD templates, utility scripts (bash for Linux/macOS, PowerShell for Windows), and the `memory/` subdirectory
**Installation:**
```bash
# Persistent (recommended)
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
# One-time usage
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --ai claude --script ps --force
```
**Prerequisites:** Linux/macOS/Windows, Python 3.11+, `uv` package manager, Git, and a supported AI coding agent.
During `specify init`, the CLI asks which AI agent you are using and generates the corresponding prompt/command files for that agent.
---
### Supported AI Agents (23+)
Claude Code, GitHub Copilot, Gemini CLI, Cursor, Windsurf, Qwen Code, opencode, Codex, Kilo Code, Auggie, Roo Code, CodeBuddy, Qoder, Kiro, Amp, SHAI, IBM Bob, Jules, and a generic/custom agent option.
---
### Core Slash Commands
These commands are generated as agent-specific files and invoked inside the respective agent's environment:
| Command | Purpose |
|---|---|
| `/speckit.constitution` | Establish project principles and non-negotiable development guidelines |
| `/speckit.specify` | Define what you want to build (requirements, not technical choices) |
| `/speckit.clarify` | Resolve underspecified areas before planning begins |
| `/speckit.plan` | Create technical implementation plan (tech stack, architecture, data models, contracts) |
| `/speckit.tasks` | Generate actionable, ordered task breakdown from the plan |
| `/speckit.implement` | Execute all tasks according to the plan |
| `/speckit.analyze` | Cross-artifact consistency and coverage analysis |
| `/speckit.checklist` | Generate quality validation checklists |
---
### The `spec.md` File Format
The spec.md file is generated by `/speckit.specify`. It documents **what you're building** — not how. It is strictly functional, with no implementation details (no frameworks, APIs, or languages).
Key characteristics of the generated spec:
- Functional requirements are assigned IDs (e.g., `FR-002`, `FR-008`, `FR-012`)
- Ambiguities are marked with `[NEEDS CLARIFICATION: specific question]` rather than being guessed — e.g., `"FR-006: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]"`
- Success criteria must be user-focused metrics, not system internals — e.g., "Users complete checkout in under 3 minutes" not "API response under 200ms"
- The spec covers: user stories, personas, acceptance criteria, user scenarios/journeys, workflows, success metrics, edge cases, and dependencies
**What it does NOT contain:** tech stack choices, framework names, database choices, API design, or implementation decisions — those belong in `plan.md`.
The specify command process:
1. Generates a short 2-4 word action-noun name for the feature
2. Scans existing specs to determine the next feature number
3. Creates a semantic branch name
4. Parses the user's description and extracts actors, actions, data, constraints
5. Fills specification sections, marking unknowns with `[NEEDS CLARIFICATION]`
6. Validates the spec against a quality checklist (testability, completeness, no implementation details)
7. Asks at most 3 clarifying questions for critical decisions affecting scope or security
---
### The `plan.md` File Format
Generated by `/speckit.plan`. Contains:
- **Branch name, date, spec link**
- **Summary**: Primary requirement and technical approach
- **Technical Context**: Language/version, primary dependencies, storage, testing framework, target platform, project type, performance goals, constraints, scale/scope — all marked as specified or `NEEDS CLARIFICATION`
- **Constitution Check**: A gating mechanism requiring explicit approval before Phase 0 (research) and re-evaluation after Phase 1 (design)
- **Project Structure**: Documentation layout (plan.md, research.md, data-model.md, quickstart.md, contracts/, tasks.md) and source code layout
- **Complexity Tracking**: A table for documenting any constitution violations with justification columns
The plan command runs in two phases:
- **Phase 0 (Research)**: Dispatches research agents to resolve all `[NEEDS CLARIFICATION]` items, consolidating into `research.md`
- **Phase 1 (Design)**: Generates `data-model.md` from entity extraction, defines interface contracts in `/contracts/`, and produces `quickstart.md`
---
### The `constitution.md` File
Stored at `memory/constitution.md`. Establishes nine immutable articles that govern all AI-generated code:
- **Article I (Library-First)**: Every feature must begin as a standalone library — no exceptions.
- **Article II (CLI Interface Mandate)**: All CLI interfaces must accept text as input, produce text as output, and support JSON format.
- **Article III (Test-First Imperative)**: No implementation code shall be written before tests are written, validated, approved, and confirmed to FAIL.
- **Articles VII & VIII (Simplicity and Anti-Abstraction)**: Maximum 3 projects for initial implementation. Use framework features directly rather than wrapping them.
- **Article IX (Integration-First Testing)**: Prefer real databases over mocks. Use actual service instances over stubs.
These articles are enforced by the plan template through explicit "gates" — checkpoints that produce an ERROR if an architectural violation lacks justification.
---
### The `tasks.md` File
Generated by `/speckit.tasks`. Converts the plan's contracts, entities, and scenarios into specific, ordered, actionable tasks. Independent tasks are marked for parallelization. Tests are ordered: contract tests first, then integration, then e2e, then unit.
---
### Directory Structure After `specify init`
```
.specify/
  memory/
    constitution.md        # Project principles (immutable)
  templates/
    spec-template.md       # Template for spec.md generation
    plan-template.md       # Template for plan.md generation
  commands/
    specify.md             # Instructions for /speckit.specify
    plan.md                # Instructions for /speckit.plan
    tasks.md               # Instructions for /speckit.tasks
    implement.md           # Instructions for /speckit.implement
    clarify.md             # Instructions for /speckit.clarify
    analyze.md             # Instructions for /speckit.analyze
    checklist.md           # Instructions for /speckit.checklist
specs/
  <feature-number>-<feature-name>/
    spec.md                # Generated by /speckit.specify
    plan.md                # Generated by /speckit.plan
    research.md            # Generated during Phase 0
    data-model.md          # Generated during Phase 1
    quickstart.md          # Generated during Phase 1
    contracts/             # API/interface contracts
    tasks.md               # Generated by /speckit.tasks
.github/                   # Agent-specific prompt files
```
---
### How It Works with AI / Vibe Coding
spec-kit is explicitly designed as a structured antidote to "vibe coding." The key insight is that LLMs produce poor results not because they lack capability, but because developers struggle to define exactly what they want in a prompt. spec-kit addresses this by:
1. **Separating design from implementation phases** — the human governs the spec; the AI governs the code.
2. **Template-driven quality** — templates constrain LLM behavior: they enforce abstraction level control (WHAT and WHY only), require explicit `[NEEDS CLARIFICATION]` markers instead of hallucinated assumptions, embed structured checklists for self-review, and install constitutional gates requiring justification for complexity.
3. **Technology independence** — the same specifications work across different agents and tech stacks, demonstrating that SDD is a process, not a tool-specific feature.
4. **Multi-step refinement** — rather than single-shot code generation from a basic prompt, the workflow runs through specification, clarification, planning, and task breakdown before implementation.
5. **Rich context** — each agent is updated with project context between steps so that later commands have full awareness of prior decisions.
The martinfowler.com analysis notes that spec-kit leans toward "spec-first" and "spec-anchored" (though not fully "spec-as-source" like Tessl). It creates many markdown files which some find "verbose and tedious to review" for small tasks, but which provide significant structure for large or team-based projects.
---
### Key Sources
- [GitHub spec-kit repository](https://github.com/github/spec-kit)
- [spec-kit spec-driven.md (methodology document)](https://github.com/github/spec-kit/blob/main/spec-driven.md)
- [Thoughtworks: Spec-driven development](https://thoughtworks.medium.com/spec-driven-development-d85995a81387)
- [Martin Fowler: Understanding SDD — Kiro, spec-kit, and Tessl](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)
- [Microsoft Developer Blog: Diving Into Spec-Driven Development With GitHub Spec Kit](https://developer.microsoft.com/blog/spec-driven-development-spec-kit)
- [Tessl/ainativedev: A Look at Spec Kit](https://tessl.io/blog/a-look-at-spec-kit-githubs-spec-driven-software-development-toolkit)
- [IntuitionLabs: GitHub Spec Kit Guide](https://intuitionlabs.ai/articles/spec-driven-development-spec-kit)
- [LogRocket: Exploring spec-driven development with GitHub Spec Kit](https://blog.logrocket.com/github-spec-kit/)
- [Thoughtworks (full article)](https://www.thoughtworks.com/en-us/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices)