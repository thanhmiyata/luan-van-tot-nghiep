#!/usr/bin/env python3
"""
Setup script for Multi-Agent Text-to-SQL System
Installs dependencies and sets up environment
"""
import os
import subprocess
import sys
from pathlib import Path


def run_command(command, description):
    """Run shell command with description"""
    print(f"🔧 {description}...")
    try:
        subprocess.run(command, shell=True, check=True)
        print(f"✅ {description} completed")
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed: {e}")
        return False
    return True


def main():
    """Main setup function"""
    print("🚀 Setting up Multi-Agent Text-to-SQL System")
    print("=" * 50)

    # Create virtual environment
    if not Path("venv").exists():
        if not run_command("python -m venv venv", "Creating virtual environment"):
            return

    # Activate venv and install requirements
    if sys.platform == "win32":
        pip_path = "venv\\Scripts\\pip"
        python_path = "venv\\Scripts\\python"
    else:
        pip_path = "venv/bin/pip"
        python_path = "venv/bin/python"

    # Upgrade pip
    run_command(f"{pip_path} install --upgrade pip", "Upgrading pip")

    # Install requirements
    if not run_command(f"{pip_path} install -r requirements.txt", "Installing dependencies"):
        return

    # Create .env file if not exists
    if not Path(".env").exists():
        if Path(".env.example").exists():
            run_command("cp .env.example .env" if sys.platform != "win32" else "copy .env.example .env",
                        "Creating .env file from example")
            print("⚠️  Please edit .env file with your API keys")
        else:
            print("⚠️  No .env.example found, please create .env manually")

    print("\n🎉 Setup completed!")
    print("\nNext steps:")
    print("1. Edit .env file with your API keys")
    print("2. Start database: docker-compose up -d")
    print("3. Run demo: python run_experiment.py")
    print("4. Run tests: python run_experiment.py --mode test")


if __name__ == "__main__":
    main()
