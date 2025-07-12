**Purpose**: Audit & reorganize project planning documents during phase transitions

---

@include shared/universal-constants.yml#Universal_Legend

## Command Execution
Execute: immediate. --plan→show plan first
Legend: Generated based on symbols used in command
Purpose: "Audit planning documents for phase transition in $ARGUMENTS"

Audits completed work against planning documents, reorganizes plans by completion status, consolidates duplicates, and ensures clean state for upcoming phases.

@include shared/flag-inheritance.yml#Universal_Always

## Command-Specific Flags

**Phase Definition**:
- **--completed** "*phases 1-4*" → Define completed phases/milestones for audit
- **--upcoming** "*phases 5+*" → Define upcoming phases requiring clean planning
- **--sources** "*prs,docs,commits*" → Sources to analyze for completion status

**Directory Structure**:
- **--plans-dir** "*docs/plans*" → Directory containing planning documents  
- **--done-dir** "*docs/plans/done*" → Directory for completed plans
- **--worktree** "*checkpoint-audit*" → Worktree name for isolated audit work
- **--branch** "*audit/phase-transition*" → Branch name for audit work

Examples:
- `--checkpoint --completed "phases 1-4" --upcoming "phases 5+"`
- `--checkpoint --completed "sprint 1-3" --upcoming "sprint 4+" --plans-dir "docs/sprints"`
- `--checkpoint --completed "milestones A-C" --upcoming "milestones D+" --plans-dir "planning" --done-dir "archive/completed" --branch "audit/milestone-cleanup"`

## Execution Workflow

**Phase 1: Environment Setup**
- Creates isolated worktree for audit work
- Syncs w/ remote main branch → switches to audit branch

**Phase 2: Assessment**
- Analyzes completed work from specified sources
- Reviews planning documents in plans directory
- Maps completed work to existing plans

**Phase 3: Audit & Categorization**
- Categorizes plans: completed | remaining | duplicate
- Identifies gaps in planning for upcoming phases
- Generates audit report w/ recommendations

**Phase 4: Reorganization**
- Moves completed plans→done directory
- Consolidates duplicate plans
- Updates remaining plans for clarity

**Phase 5: Validation**
- Ensures remaining plans ready for next phases
- Verifies no critical planning gaps exist
- Confirms clean state for continuation

**Phase 6: Commit Strategy**
- Frequent small commits w/ descriptive messages
- Maintains audit trail of all changes
- Prepares for merge back to main

## Intelligence Features

- **Smart Detection**: Auto-identifies completed work patterns
- **Duplicate Analysis**: Semantic comparison of planning documents  
- **Dependency Mapping**: Understands plan interdependencies
- **Gap Analysis**: Identifies missing planning for upcoming phases

## Output & Integration

**Deliverables**:
- Audit report w/ recommendations
- Reorganized planning directory structure
- Clean branch ready for merge
- Summary of changes made

**Safety & Integration**:
- Creates isolated environment for audit work
- Maintains audit trail of all changes
- Requires explicit confirmation for destructive operations
- Preserves original documents until audit completion
- Works w/ existing project structures & git workflow

@include shared/docs-patterns.yml#Standard_Notifications

@include shared/universal-constants.yml#Standard_Messages_Templates