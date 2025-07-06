#!/usr/bin/env python3
"""
Quick start script for Multi-Agent Text-to-SQL Experiment
Usage: python run_experiment.py
"""
from src.multi_agent_coordinator import MultiAgentCoordinator
import asyncio
import os
import sys
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Add src to path
sys.path.append(os.path.join(os.path.dirname(__file__), 'src'))


async def quick_demo():
    """Quick demo of multi-agent system"""
    print("🚀 Multi-Agent Text-to-SQL Demo")
    print("=" * 50)

    coordinator = MultiAgentCoordinator()

    # Test queries
    test_queries = [
        "Có bao nhiêu phim trong cơ sở dữ liệu?",
        "How many customers are there?",
        "Liệt kê tên các thể loại phim",
        "Show the first 5 films"
    ]

    for i, query in enumerate(test_queries, 1):
        print(f"\n📝 Test {i}: {query}")
        print("-" * 30)

        result = await coordinator.process_query(query)

        if result["success"]:
            print(f"✅ Success")
            print(f"SQL: {result['sql_query']}")
            print(f"Response: {result['response']['response']}")
            print(f"Time: {result['pipeline_performance']['total_time']:.2f}s")
        else:
            print(f"❌ Failed: {result.get('error_message', 'Unknown error')}")

    # Performance summary
    print(f"\n📊 Performance Summary:")
    report = coordinator.get_performance_report()
    metrics = report["coordinator_metrics"]
    print(f"Accuracy: {metrics['accuracy']*100:.1f}%")
    print(f"Avg Response Time: {metrics['average_response_time']:.2f}s")
    print(f"Meets Target: {'✅' if metrics['meets_accuracy_target'] else '❌'}")


async def interactive_mode():
    """Interactive mode for testing queries"""
    print("🤖 Interactive Multi-Agent Mode")
    print("Type your questions (or 'exit' to quit)")
    print("=" * 50)

    coordinator = MultiAgentCoordinator()

    while True:
        query = input("\n💬 Your question: ").strip()

        if query.lower() in ['exit', 'quit', 'q']:
            break

        if not query:
            continue

        print("🔄 Processing...")
        result = await coordinator.process_query(query)

        if result["success"]:
            print(f"✅ {result['response']['response']}")
            print(f"📄 SQL: {result['sql_query']}")
        else:
            print(f"❌ Error: {result.get('error_message', 'Unknown error')}")


def main():
    """Main function"""
    import argparse

    parser = argparse.ArgumentParser(
        description="Multi-Agent Text-to-SQL Experiment")
    parser.add_argument("--mode", choices=["demo", "interactive", "test"],
                        default="demo", help="Run mode")

    args = parser.parse_args()

    if args.mode == "demo":
        asyncio.run(quick_demo())
    elif args.mode == "interactive":
        asyncio.run(interactive_mode())
    elif args.mode == "test":
        # Run full test suite
        os.system("python test_multi_agent_system.py")


if __name__ == "__main__":
    main()
