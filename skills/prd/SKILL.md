---
name: prd
description: "Generate a Product Requirements Document (PRD) for a new feature. Use when planning a feature, starting a new project, or when asked to create a PRD. Triggers on: create a prd, write prd for, plan this feature, requirements for, spec out."
---

# PRD Generator

Create detailed Product Requirements Documents that are clear, actionable, and suitable for implementation by developers or AI agents.

---

## The Job

1. Receive a feature description from the user
2. Ask 3-5 essential clarifying questions (with lettered options)
3. Generate a structured PRD based on answers
4. (Optional) Request review from Gemini/Codex for validation
5. Save to `tasks/prd-[feature-name].md`

**Important:** Do NOT start implementing. Just create the PRD.

---

## Step 1: Clarifying Questions

Ask only critical questions where the initial prompt is ambiguous. Focus on:

- **Problem/Goal:** What problem does this solve?
- **Core Functionality:** What are the key actions?
- **Scope/Boundaries:** What should it NOT do?
- **Success Criteria:** How do we know it's done?
- **Constraints:** Any technical, time, or resource constraints?

### Format Questions Like This:

```
1. What is the primary goal of this feature?
   A. Improve user onboarding experience
   B. Increase user retention
   C. Reduce support burden
   D. Other: [please specify]

2. Who is the target user?
   A. New users only
   B. Existing users only
   C. All users
   D. Admin users only

3. What is the scope?
   A. Minimal viable version
   B. Full-featured implementation
   C. Just the backend/API
   D. Just the UI
```

This lets users respond with "1A, 2C, 3B" for quick iteration.

---

## Step 2: PRD Structure

Generate the PRD with these sections:

### 1. Introduction/Overview
Brief description of the feature and the problem it solves.

### 2. Goals
Specific, measurable objectives (bullet list).

### 3. Assumptions

List assumptions that this PRD is based upon. This section is critical for AI agents to understand constraints and avoid incorrect decisions.

**Include assumptions about:**
- Technical environment (frameworks, languages, existing infrastructure)
- User behavior and expectations
- External dependencies and integrations
- Data availability and formats
- Performance baselines
- Team/resource constraints

**Example:**
```markdown
## Assumptions
- The existing PostgreSQL database can handle additional load from this feature
- Users have already completed onboarding before accessing this feature
- The design system's existing button components will be reused
- API response times under 200ms are acceptable
- Mobile support is not required for v1
```

### 4. User Stories
Each story needs:
- **Title:** Short descriptive name
- **Description:** "As a [user], I want [feature] so that [benefit]"
- **Acceptance Criteria:** Verifiable checklist of what "done" means. If the description mentions a specific library, SDK, or framework, at least one acceptance criterion must explicitly reference it by name.

Each story should be small enough to implement in one focused session.

**Format:**
```markdown
### US-001: [Title]
**Description:** As a [user], I want [feature] so that [benefit].

**Acceptance Criteria:**
- [ ] Specific verifiable criterion
- [ ] Another criterion
- [ ] Typecheck/lint passes
- [ ] **[UI stories only]** Verify in browser using dev-browser skill (or Playwright/Puppeteer fallback)
```

**Important:** 
- Acceptance criteria must be verifiable, not vague. "Works correctly" is bad. "Button shows confirmation dialog before deleting" is good.
- **For any story with UI changes:** Always include browser verification as acceptance criteria. Prefer the `dev-browser` skill if installed; otherwise use Playwright or Puppeteer directly.

### 5. Functional Requirements
Numbered list of specific functionalities:
- "FR-1: The system must allow users to..."
- "FR-2: When a user clicks X, the system must..."

Be explicit and unambiguous.

### 6. Non-Functional Requirements

Specify quality attributes the system must meet. This section prevents technical debt and ensures production readiness.

**Categories to consider:**

**Performance:**
- Response time targets (e.g., "API responses under 200ms at p95")
- Throughput requirements (e.g., "Handle 100 concurrent users")
- Resource limits (e.g., "Memory usage under 512MB")

**Security:**
- Authentication/authorization requirements
- Data encryption needs
- Input validation rules
- Audit logging requirements

**Reliability:**
- Uptime targets (e.g., "99.9% availability")
- Error handling expectations
- Graceful degradation behavior
- Backup/recovery requirements

**Usability:**
- Accessibility standards (e.g., "WCAG 2.1 AA compliance")
- Browser/device support
- Internationalization needs

**Maintainability:**
- Code coverage targets
- Documentation requirements
- Logging/monitoring needs

**Example:**
```markdown
## Non-Functional Requirements
- NFR-1: All API endpoints must respond within 200ms at p95 under normal load
- NFR-2: User input must be sanitized to prevent XSS attacks
- NFR-3: All form fields must have appropriate ARIA labels for screen readers
- NFR-4: Error states must display user-friendly messages, not stack traces
- NFR-5: All database queries must use parameterized statements
- NFR-6: Feature must work in Chrome, Firefox, Safari (latest 2 versions)
```

### 7. Non-Goals (Out of Scope)
What this feature will NOT include. Critical for managing scope.

### 8. Design Considerations (Optional)
- UI/UX requirements
- Link to mockups if available
- Relevant existing components to reuse

### 9. Technical Considerations (Optional)
- Known constraints or dependencies
- Integration points with existing systems
- Performance requirements

### 10. Success Metrics
How will success be measured?
- "Reduce time to complete X by 50%"
- "Increase conversion rate by 10%"

### 11. Open Questions
Remaining questions or areas needing clarification.

---

## Writing for AI Agents and Junior Developers

The PRD reader may be a junior developer or AI agent. Therefore:

- Be explicit and unambiguous
- Avoid jargon or explain it
- Provide enough detail to understand purpose and core logic
- Number requirements for easy reference
- Use concrete examples where helpful
- State assumptions explicitly - don't assume shared context

---

## Step 3: Optional Review with Gemini/Codex

After generating the PRD, offer to validate it using the agent skills:

```
Would you like me to get a second opinion on this PRD from Gemini or Codex?

- **Gemini**: Good for validating architecture decisions, researching current best practices
- **Codex**: Good for checking technical feasibility, identifying implementation gotchas

Reply with "review with gemini", "review with codex", or "both" to proceed.
```

**If user requests review:**

**For Gemini review:**
```bash
gemini "Review this PRD for completeness, feasibility, and potential issues. Check if assumptions are reasonable and if non-functional requirements are comprehensive. PRD content: [paste PRD]"
```

**For Codex review:**
```bash
codex exec --sandbox read-only "Review this PRD for technical feasibility. Identify potential implementation challenges, missing edge cases, and suggest improvements. PRD content: [paste PRD]" 2>/dev/null
```

**After review, synthesize feedback:**
- Note which suggestions are valuable
- Filter out generic or inapplicable advice
- Update PRD if substantive improvements are identified
- Document any unresolved concerns in Open Questions

---

## Output

- **Format:** Markdown (`.md`)
- **Location:** `tasks/`
- **Filename:** `prd-[feature-name].md` (kebab-case)

---

## Example PRD

```markdown
# PRD: Task Priority System

## Introduction

Add priority levels to tasks so users can focus on what matters most. Tasks can be marked as high, medium, or low priority, with visual indicators and filtering.

## Goals

- Allow assigning priority (high/medium/low) to any task
- Provide clear visual differentiation between priority levels
- Enable filtering and sorting by priority
- Default new tasks to medium priority

## Assumptions

- Existing task table can be modified with a new column (no migration conflicts)
- Users understand priority concepts without explanation
- Color coding (red/yellow/gray) is sufficient visual differentiation
- Current badge component supports color variants
- Filter state can be stored in URL params without breaking existing routing

## User Stories

### US-001: Add priority field to database
**Description:** As a developer, I need to store task priority so it persists across sessions.

**Acceptance Criteria:**
- [ ] Add priority column to tasks table: 'high' | 'medium' | 'low' (default 'medium')
- [ ] Generate and run migration successfully
- [ ] Typecheck passes

### US-002: Display priority indicator on task cards
**Description:** As a user, I want to see task priority at a glance so I know what needs attention first.

**Acceptance Criteria:**
- [ ] Each task card shows colored priority badge (red=high, yellow=medium, gray=low)
- [ ] Priority visible without hovering or clicking
- [ ] Typecheck passes
- [ ] Verify in browser using dev-browser skill

### US-003: Add priority selector to task edit
**Description:** As a user, I want to change a task's priority when editing it.

**Acceptance Criteria:**
- [ ] Priority dropdown in task edit modal
- [ ] Shows current priority as selected
- [ ] Saves immediately on selection change
- [ ] Typecheck passes
- [ ] Verify in browser using dev-browser skill

### US-004: Filter tasks by priority
**Description:** As a user, I want to filter the task list to see only high-priority items when I'm focused.

**Acceptance Criteria:**
- [ ] Filter dropdown with options: All | High | Medium | Low
- [ ] Filter persists in URL params
- [ ] Empty state message when no tasks match filter
- [ ] Typecheck passes
- [ ] Verify in browser using dev-browser skill

## Functional Requirements

- FR-1: Add `priority` field to tasks table ('high' | 'medium' | 'low', default 'medium')
- FR-2: Display colored priority badge on each task card
- FR-3: Include priority selector in task edit modal
- FR-4: Add priority filter dropdown to task list header
- FR-5: Sort by priority within each status column (high to medium to low)

## Non-Functional Requirements

- NFR-1: Priority filter must not add perceptible latency to task list rendering
- NFR-2: Badge colors must meet WCAG 2.1 AA contrast requirements
- NFR-3: Filter dropdown must be keyboard accessible
- NFR-4: Priority changes must persist within 500ms
- NFR-5: Filter state in URL must not break browser back/forward navigation

## Non-Goals

- No priority-based notifications or reminders
- No automatic priority assignment based on due date
- No priority inheritance for subtasks

## Technical Considerations

- Reuse existing badge component with color variants
- Filter state managed via URL search params
- Priority stored in database, not computed

## Success Metrics

- Users can change priority in under 2 clicks
- High-priority tasks immediately visible at top of lists
- No regression in task list performance

## Open Questions

- Should priority affect task ordering within a column?
- Should we add keyboard shortcuts for priority changes?
```

---

## Checklist

Before saving the PRD:

- [ ] Asked clarifying questions with lettered options
- [ ] Incorporated user's answers
- [ ] User stories are small and specific
- [ ] **Assumptions section documents technical and user expectations**
- [ ] **Non-functional requirements cover performance, security, usability**
- [ ] Functional requirements are numbered and unambiguous
- [ ] Non-goals section defines clear boundaries
- [ ] Offered optional Gemini/Codex review
- [ ] Saved to `tasks/prd-[feature-name].md`
