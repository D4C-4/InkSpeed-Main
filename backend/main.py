"""Start the MySQL API used by the React/TanStack frontend."""
from __future__ import annotations

import logging

from api_server import app
from database.connection import DatabaseInitializationError, initialize_database
from database.database_manager import seed_defaults


def main() -> int:
    logging.basicConfig(
        level=logging.INFO,
        format="%(levelname)s %(name)s: %(message)s",
    )
    try:
        initialize_database()
        seed_defaults()
    except DatabaseInitializationError:
        # The error has already been logged with the safe recovery path. Exit
        # non-zero so Electron reports this failure instead of waiting for a
        # health check that can never succeed.
        return 1
    app.run(host="127.0.0.1", port=5000, debug=False)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
