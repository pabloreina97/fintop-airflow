"""Tests de integridad de DAGs."""
from pathlib import Path

import pytest
from airflow.models import DagBag

DAGS_DIR = Path(__file__).parent.parent.parent / "dags"


@pytest.fixture(scope="module")
def dag_bag():
    """Cargar todos los DAGs una vez por módulo."""
    return DagBag(dag_folder=str(DAGS_DIR), include_examples=False)


def test_dags_load_without_errors(dag_bag):
    """Verificar que todos los DAGs se carguen sin errores."""
    assert len(dag_bag.import_errors) == 0, (
        f"Errores de importación: {dag_bag.import_errors}"
    )


def test_dags_have_tags(dag_bag):
    """Verificar que todos los DAGs tengan tags."""
    for dag_id, dag in dag_bag.dags.items():
        assert dag.tags, f"DAG '{dag_id}' no tiene tags"


def test_dags_have_description(dag_bag):
    """Verificar que todos los DAGs tengan descripción."""
    for dag_id, dag in dag_bag.dags.items():
        assert dag.description, f"DAG '{dag_id}' no tiene descripción"


def test_dags_no_duplicate_task_ids(dag_bag):
    """Verificar que no haya IDs de tareas duplicados."""
    for dag_id, dag in dag_bag.dags.items():
        task_ids = [task.task_id for task in dag.tasks]
        assert len(task_ids) == len(set(task_ids)), (
            f"DAG '{dag_id}' tiene task_ids duplicados"
        )


def test_dags_have_retries(dag_bag):
    """Verificar que las tareas tengan configuración de reintentos."""
    for dag_id, dag in dag_bag.dags.items():
        for task in dag.tasks:
            assert task.retries is not None and task.retries >= 0, (
                f"Tarea '{task.task_id}' en DAG '{dag_id}' no tiene retries"
            )
