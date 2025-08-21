"""Utilities related to lead history/logging.

Provides `log_lead_change` used by admin flows. Works against reflected models
via SQLAlchemy automap and is safe if tables are missing.
"""
from __future__ import annotations

from datetime import datetime
from typing import Any

from dux import db
from dux.models import Base


def log_lead_change(lead_id: Any, new_state_id: int | None, note: str | None = None) -> None:
    """Append a row into `lead_history` if the table exists.

    Parameters:
    - lead_id: identifier of the lead
    - new_state_id: target state id (optional)
    - note: optional comment/reason
    """
    LeadHistory = getattr(Base.classes, "lead_history", None)
    if LeadHistory is None:
        return
    try:
        row = LeadHistory(
            lead_id=lead_id,
            state_id=new_state_id,
            note=note,
            created_at=datetime.utcnow(),
        )
        db.session.add(row)
        # Commit is responsibility of the caller in most flows; but make it safe.
        db.session.flush()
    except Exception:
        # Be non-fatal: logging history should not break the request flow.
        db.session.rollback()
        try:
            db.session.begin()
        except Exception:
            pass
