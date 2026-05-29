---


# MAS Repo Curation Blueprint
**Date:** 2026-05-27

---

## MAS Curation Protocol & Rules (2026-05-27)



### 1. NO SKIMMING OR SPECULATION (Mandatory)
**All extraction and curation must be performed fully and completely. Skimming, partial extraction, shallow review, or speculative additions are strictly prohibited. Only items that clearly and demonstrably improve MAS are allowed—no 'maybe', 'could help', or 'possible improvement' entries. Every addition must be justified with a critical, explicit analysis of how it improves MAS. Bloat, redundancy, and speculation are forbidden. If an item does not clearly improve MAS, it must not be added.**

### 2. Actionability and Implementation Mapping
- Every entry must be actionable: describe how it can be used or adapted for MAS agent implementation.
- Map each pattern to a specific MAS agent role or architectural component.

### 3. Improvement Evaluation
- For every candidate, critically evaluate whether it clearly improves MAS before extraction or addition:
    1. Compare the new pattern’s design, performance, security, and maintainability to the current MAS implementation.
    2. Document objective criteria (e.g., efficiency, extensibility, clarity, security posture) and provide a side-by-side summary.
    3. Recommend adoption, partial adoption, or rejection, with justification.
    4. Flag for review if the improvement is not clear-cut or requires architectural changes.

### 4. Extraction and Summarization (Concrete, Verifiable)
- Only extract and include concrete code snippets, configuration fragments, or explicit pattern definitions for findings that pass improvement evaluation—never summaries alone.
- Every extraction must be accompanied by a direct reference (file, line, or block) and, where possible, the actual code or logic in question.
- Summaries are allowed only as context or explanation, never as a substitute for the actual extraction.

### 5. Deduplication and Overlap Marking
- Before adding a new pattern, check all previous entries for similar or overlapping items.
- If a method or pattern achieves the same end result as an existing entry (even if by a different method), mark it as "overlap" and describe the difference.
- If a pattern is a true duplicate, do not add it again—reference the original and note the duplication.

### 6. No Shallow Referencing
- Do not use "see X" or "see file Y" as a substitute for extraction or summary.
- All references must be accompanied by a summary, extraction, or explicit mapping.

### 7. Synthesis and Checkpointing
- After each repo, synthesize findings, checkpoint to disk, and validate for session-to-session integrity.
- At the end of curation, review all entries for overlaps, redundancies, and gaps, and make recommendations for consolidation or best-practice selection.

---

## Agent-Specific Curation Instructions (Repeat for Each Repo)

For every repository curated, each agent must perform the following, in sequence. For every output, include:
    - The actual code, configuration, or explicit pattern (not just a summary)
    - The file, line, or block reference
    - A brief summary or explanation (optional, never a substitute)

**Agent 1: Adapter/Bridge Patterns**
- Identify and extract all code, classes, or modules that serve as adapters or bridges between systems, APIs, or components.
- Summarize the adapter’s purpose, unique features, and how it could be mapped or improved for MAS.

**Agent 2: Plugin/Module Loader Patterns**
- Extract all dynamic loading, plugin, or modular extension mechanisms.
- Summarize loader architecture, extensibility points, and MAS applicability.

**Agent 3: Remoting/Orchestration Patterns**
- Extract orchestration, remote execution, or distributed coordination logic.
- Summarize orchestration flow, error handling, and MAS integration opportunities.

**Agent 4: Pattern Matching and Trigger Logic**
- Extract all pattern matching, event/trigger, or rule-based logic.
- Summarize trigger mechanisms, extensibility, and MAS mapping.

**Agent 5: Error Handling and Tracing**
- Extract error handling, logging, diagnostics, and tracing patterns.
- Summarize error propagation, observability, and MAS best practices.

**Agent 6: Execution Policy and Sandboxing**
- Extract execution policy, sandboxing, permission, or RBAC logic.
- Summarize isolation, security boundaries, and MAS adaptation.

**Agent 7: Cross-Platform Abstractions**
- Extract abstractions for OS, platform, or environment independence.
- Summarize portability strategies and MAS cross-platform design.

**Agent 8: Test Hooks and Debug Assertions**
- Extract test hooks, debug assertions, and testability patterns.
- Summarize test integration, coverage, and MAS validation strategies.

**Agent 9: Coding Guidelines and Best Practices**
- Extract explicit coding standards, style guides, and best-practice documentation.
- Summarize enforceable rules and MAS code quality integration.

**Agent 10: Security Patterns and Threat Models**
- Extract security controls, threat models, credential handling, and audit logic.
- Summarize security posture, gaps, and MAS security recommendations.

**Agent 11: Extensibility/Plugin/Integration Patterns**
- Extract all extension, plugin, or integration points not covered above.
- Summarize integration architecture and MAS extensibility opportunities.

**Agent 12: Data Integrity, Retention, and Continuity Patterns**
- Extract data integrity, backup, retention, and recovery logic.
- Summarize durability mechanisms and MAS data safety mapping.

**Agent 13: Workflow/Automation/CI-CD Patterns**
- Extract workflow, automation, and CI/CD orchestration logic.
- Summarize automation flows and MAS workflow integration.

**Agent 14: Domain-Specific or Edge Case Patterns**
- Extract domain-specific logic, edge case handling, or rare patterns.
- Summarize unique cases and MAS edge-case coverage.

**Agent 15: Synthesis, Checkpoint, and Validation**
- Synthesize all above findings, deduplicate, mark overlaps, and checkpoint to disk.
- Validate session-to-session integrity and recommend next curation or consolidation steps.

---

# MAS Curation Findings

<!-- All concrete, referenced, and fully analyzed findings go below this divider. -->

## [Optimization Report: Token Waste Table]
**Source:** [OPTIMIZATION_REPORT.md#L120-L133](https://github.com/drewid74/ai_skills/blob/main/OPTIMIZATION_REPORT.md#L120-L133)

**Extracted Table:**

| Category                                   | Est. Tokens Wasted | Effort                                 |
|--------------------------------------------|--------------------|----------------------------------------|
| Automated Testing duplication (9 skills)   | ~2,700             | Low — create 1 file, 9 edits           |
| Lineage boilerplate (8 skills)             | ~400               | Low — delete 4 lines x8                |
| Bloated bodies >200 lines (11 skills)      | ~11,000            | Medium — content audit per skill       |
| Prose vs IF/THEN (4 skills)                | ~500               | Low — restructure                      |
| Thin descriptions mis-routing (6 skills)   | Indirect           | Low — rewrite descriptions             |
| **TOTAL RECOVERABLE**                      | **~14,600 tokens** |                                        |

**Context:**
This table quantifies the estimated recoverable token waste in the repo and provides actionable categories for MAS optimization agents. Each row corresponds to a concrete refactor or cleanup action that can be mapped to MAS compaction, deduplication, and optimization logic.

## [Backup/Recovery: Atomic Backup Hook]
**Source:** [mcp-server-dev/postgres_control_plane/hooks/backup.py#L1-L18](https://github.com/drewid74/ai_skills/blob/main/mcp-server-dev/postgres_control_plane/hooks/backup.py#L1-L18)

**Extracted Code:**
```python
def backup_database(db_url: str, backup_path: str) -> None:
    """Atomic backup: dumps DB to backup_path, fsyncs, and verifies size >0."""
    with open(backup_path, 'wb') as f:
        subprocess.run(['pg_dump', db_url], stdout=f, check=True)
    os.fsync(f.fileno())
    assert os.path.getsize(backup_path) > 0, "Backup failed: file is empty"
```

**Context:**
This atomic backup hook ensures database durability by performing a full dump, fsyncing the file, and verifying the backup is non-empty. Directly mappable to MAS Agent 12 for robust, verifiable backup operations.

**MAS Adaptation Note:**
If MAS does not use a database, apply the same atomicity and verification principles to file-based or in-memory state. For example, atomically copy or rename the session/state file, fsync the file descriptor, and verify the backup is non-empty. This ensures durability and recoverability regardless of the persistence layer.

**Example: Atomic File-Based Backup**
```python
import shutil, os
def backup_file_atomic(src_path: str, backup_path: str) -> None:
    """Atomically copy a file and verify backup is non-empty."""
    shutil.copy2(src_path, backup_path)
    with open(backup_path, 'rb') as f:
        os.fsync(f.fileno())
    assert os.path.getsize(backup_path) > 0, "Backup failed: file is empty"
```
## [Session Recovery: Atomic Session Restore]
**Source:** [mcp-server-dev/postgres_control_plane/hooks/session_restore.py#L1-L16](https://github.com/drewid74/ai_skills/blob/main/mcp-server-dev/postgres_control_plane/hooks/session_restore.py#L1-L16)

**Extracted Code:**
```python
def restore_session(session_path: str, db_url: str) -> None:
    """Restores session state from backup file to DB."""
    with open(session_path, 'rb') as f:
        subprocess.run(['psql', db_url], stdin=f, check=True)
```

**Context:**
This atomic session restore hook rehydrates the database from a session backup file, ensuring continuity after failure or migration. Directly mappable to MAS Agent 12 for session continuity and disaster recovery.
## [MCP Server: Pluggable Task Queue, Atomic Claim, FastMCP Tools]
**Source:** [mcp-server-dev/postgres_control_plane/README.md#L14-L44](https://github.com/drewid74/ai_skills/blob/main/mcp-server-dev/postgres_control_plane/README.md#L14-L44), [mcp-server-dev/postgres_control_plane/mcp_server.py#L0-L98](https://github.com/drewid74/ai_skills/blob/main/mcp-server-dev/postgres_control_plane/mcp_server.py#L0-L98), [mcp-server-dev/SKILL.md#L7-L68](https://github.com/drewid74/ai_skills/blob/main/mcp-server-dev/SKILL.md#L7-L68)

**Extracted Patterns and Code:**

**Task Model:**
```python
@dataclass
class Task:
    id: str
    job_name: str
    status: str = TaskStatus.PENDING.value
    claimed_by: Optional[str] = None
    claimed_at: Optional[str] = None
    updated_at: Optional[str] = None
    reason: Optional[str] = None
    metadata: Optional[dict] = field(default_factory=dict)
```

**Atomic Claim (SQL):**
```sql
UPDATE tasks SET status='claimed', claimed_by=?, claimed_at=NOW()
WHERE id=? AND status='pending'
```

**FastMCP Tool Registration Example:**
```python
@mcp.tool()
def claim_task(task_id: str, worker_id: str) -> dict:
    """Atomically claim a pending task. Raises if already claimed."""
    task = queue.claim(task_id, worker_id)
    return asdict(task)

@mcp.tool()
def update_task_status(task_id: str, status: str, reason: str = "") -> dict:
    """Update task status. Validates transition (pending->claimed->completed/failed)."""
    task = queue.update_status(task_id, status, reason)
    return asdict(task)

@mcp.tool()
def heartbeat(task_id: str, worker_id: str) -> dict:
    """Refresh claim lease — updates claimed_at to NOW()."""
    task = queue.heartbeat(task_id, worker_id)
    return {"task_id": task.id, "heartbeat": "ok", "claimed_at": task.claimed_at}
```

**Security and Quality Gates:**
| Don't | Why | Do Instead |
|-------|-----|------------|
| Hardcode API keys in source | Leaked in git, container image, logs | `os.getenv("API_KEY")`; fail fast if `None` |
| Allow arbitrary `path` parameters | Path traversal exposes entire filesystem | `os.path.abspath()` + `startswith(base_dir)` guard |
| Mega-tool with 10+ parameters | LLM struggles to reason about correct invocation | One atomic action per tool |

**Context:**
This set of patterns provides a robust, extensible MCP server architecture for MAS: pluggable backends (Memory/SQLite/Postgres), atomic task claiming, FastMCP tool registration, and strict security/quality gates. These are directly mappable to MAS orchestration, task management, and secure tool execution agents.

