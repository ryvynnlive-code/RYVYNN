# RYVYNN Unified Ops Dashboard — Notion Blueprint (Hybrid Mode)

This blueprint maps the local JSON/CSV backend to Notion databases and views.

## Databases
1. **Strategy Hub**
   - Keys: id, title, objective, kpis, milestone_date, status, priority, owner, tags
   - Default views: Roadmap (timeline), P0 Focus (filtered), All

2. **Investor Vault**
   - Keys: id, artifact_type, version, reviewer, status, priority, link
   - Views: Publishing Queue, Pending Review, Complete

3. **Compliance Core**
   - Keys: id, category, risk_level, recommendation, decision, status, owner
   - Views: Risk Board (by risk_level), Approvals, Audit Log

4. **Technical Execution Log**
   - Keys: id, component, env, commit_hash, integration, result, status, owner
   - Views: Dev, Staging, Prod

5. **Intelligence Feed**
   - Keys: id, source, summary, confidence, status, owner
   - Views: Incoming Signals, Briefings

6. **Ethics Sentinel**
   - Keys: id, detected_issue, impact, proposed_fix, status, owner
   - Views: Open Issues, Resolved

7. **Founder Command Layer**
   - Keys: id, directive, assigned_to, due_date, acceptance_criteria, status, priority
   - Views: Approvals, Due This Week

## Relations & Rollups
- Founder Command Layer ↔ Investor Vault (for approvals)
- Compliance Core ↔ Technical Execution Log (risks linked to components)
- Strategy Hub ↔ All modules (rollup: status, P0 count)

## Styling
- Cosmic-dark theme with violet→gold accent tags.
- Status chips: ✅ Complete, 🟣 Pending Review, 🔶 In Progress, 🔴 Hold, ⚫ Fail-Safe Lock.

## Operating Protocol
- Verum ingests outputs from Claude/Gemini/Perplexity.
- Updates are mirrored to JSON/CSV and Notion simultaneously.
- Weekly snapshot export (ZIP) for audit.
