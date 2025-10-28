"""
Setup script to prepare data directory structure
Copies data from parent directories if available
"""

import shutil
from pathlib import Path
import json
from loguru import logger

# Configure logging
logger.add("logs/setup_data.log", rotation="1 MB")


def create_directories(project_root: Path):
    """Create necessary directories"""
    dirs = [
        project_root / "data",
        project_root / "data" / "test_questions",
        project_root / "data" / "schemas",
        project_root / "data" / "schemas" / "database",
        project_root / "data" / "results",
        project_root / "data" / "results" / "model_3_step",
        project_root / "data" / "results" / "model_4_step",
        project_root / "data" / "results" / "model_6_step",
        project_root / "logs",
        project_root / "output"
    ]

    for dir_path in dirs:
        dir_path.mkdir(parents=True, exist_ok=True)
        logger.info(f"Created directory: {dir_path}")


def copy_if_exists(source: Path, destination: Path, description: str):
    """Copy file or directory if source exists"""
    if source.exists():
        try:
            if source.is_file():
                destination.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(source, destination)
                logger.info(f"✓ Copied {description}: {source.name}")
                return True
            elif source.is_dir():
                if destination.exists():
                    shutil.rmtree(destination)
                shutil.copytree(source, destination)
                logger.info(f"✓ Copied {description}: {source.name}")
                return True
        except Exception as e:
            logger.error(f"✗ Failed to copy {description}: {e}")
            return False
    else:
        logger.warning(f"⚠ Not found: {description} at {source}")
        return False


def setup_data(project_root: Path):
    """Setup data directory structure"""
    logger.info("="*60)
    logger.info("Setting up data directory structure")
    logger.info("="*60)

    # Create directories
    logger.info("\n1. Creating directories...")
    create_directories(project_root)

    # Copy schema data from test-suite-sql-eval
    logger.info("\n2. Copying schema data...")

    parent_dir = project_root.parent
    test_suite_dir = parent_dir / "experiments" / "test-suite-sql-eval"

    # Copy tables.json
    tables_source = test_suite_dir / "tables.json"
    tables_dest = project_root / "data" / "schemas" / "tables.json"
    copy_if_exists(tables_source, tables_dest, "tables.json")

    # Copy database directory
    db_source = test_suite_dir / "database"
    db_dest = project_root / "data" / "schemas" / "database"

    if db_source.exists():
        logger.info("Copying database directory (this may take a while)...")
        copy_if_exists(db_source, db_dest, "database directory")

    # Copy test questions
    logger.info("\n3. Copying test questions...")

    dataset_dir = parent_dir / "Data Set"

    # Copy 50_test_dataset.json
    test_50_source = dataset_dir / "50_test_dataset.json"
    test_50_dest = project_root / "data" / \
        "test_questions" / "spider_50_questions.json"
    copy_if_exists(test_50_source, test_50_dest, "50 test questions")

    # Copy level-based questions
    for level in range(1, 6):
        level_source = dataset_dir / f"lv{level}_test_question.json"
        level_dest = project_root / "data" / \
            "test_questions" / f"level_{level}_questions.json"
        copy_if_exists(level_source, level_dest, f"Level {level} questions")

    # Validate setup
    logger.info("\n4. Validating setup...")
    validate_setup(project_root)

    logger.info("\n" + "="*60)
    logger.info("Setup complete!")
    logger.info("="*60)


def validate_setup(project_root: Path):
    """Validate data directory structure"""
    checks = {
        "data directory": project_root / "data",
        "test_questions directory": project_root / "data" / "test_questions",
        "schemas directory": project_root / "data" / "schemas",
        "results directory": project_root / "data" / "results",
        "logs directory": project_root / "logs",
        "output directory": project_root / "output"
    }

    all_passed = True

    for name, path in checks.items():
        if path.exists():
            logger.info(f"✓ {name}: {path}")
        else:
            logger.warning(f"✗ {name}: NOT FOUND")
            all_passed = False

    # Check for data files
    logger.info("\nData files:")

    data_files = {
        "tables.json": project_root / "data" / "schemas" / "tables.json",
        "database directory": project_root / "data" / "schemas" / "database",
        "test questions": project_root / "data" / "test_questions"
    }

    for name, path in data_files.items():
        if path.exists():
            if path.is_file():
                size = path.stat().st_size / 1024
                logger.info(f"✓ {name}: {size:.1f} KB")
            else:
                count = len(list(path.iterdir()))
                logger.info(f"✓ {name}: {count} items")
        else:
            logger.warning(f"⚠ {name}: Not found (will use parent directory)")

    # Summary
    logger.info("\nSetup validation summary:")
    if all_passed:
        logger.info("✓ All required directories created")
    else:
        logger.warning("⚠ Some directories missing (check logs above)")

    # Check if we can fall back to parent data
    parent_data_available = check_parent_data_availability(project_root.parent)

    if parent_data_available:
        logger.info("✓ Parent directory data available as fallback")
    else:
        logger.warning("⚠ Parent directory data not found")


def check_parent_data_availability(parent_dir: Path) -> bool:
    """Check if parent directory has necessary data"""
    required_files = [
        parent_dir / "experiments" / "test-suite-sql-eval" / "tables.json",
        parent_dir / "experiments" / "test-suite-sql-eval" / "database"
    ]

    return all(f.exists() for f in required_files)


def main():
    """Main setup function"""
    project_root = Path(__file__).parent

    print("Multi-Agent SQL - Data Setup")
    print("="*60)
    print(f"Project root: {project_root}")
    print()

    try:
        setup_data(project_root)

        print("\n✅ Setup completed successfully!")
        print("\nNext steps:")
        print("  1. Create .env file with your API keys (see env.example)")
        print("  2. Run test: python test_system.py")
        print("  3. Run benchmark: python experiments/run_benchmark.py")

    except Exception as e:
        print(f"\n❌ Setup failed: {e}")
        import traceback
        traceback.print_exc()
        return 1

    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
