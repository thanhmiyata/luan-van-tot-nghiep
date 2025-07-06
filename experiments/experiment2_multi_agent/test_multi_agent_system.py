"""
Test Multi-Agent Text-to-SQL System
Chạy thử nghiệm với 6-agent architecture
Target: 90%+ accuracy (theo paper thầy: 91.95%)
"""
from src.multi_agent_coordinator import MultiAgentCoordinator
import sys
import asyncio
import json
import logging
import os
from datetime import datetime
from typing import Dict, Any, List

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Add src to path
sys.path.append(os.path.join(os.path.dirname(__file__), 'src'))


class MultiAgentTester:
    """Test suite for Multi-Agent system"""

    def __init__(self):
        self.coordinator = MultiAgentCoordinator()
        self.test_queries = {
            "vi": [
                "Có bao nhiêu bộ phim trong cơ sở dữ liệu?",
                "Liệt kê tên tất cả các thể loại phim.",
                "Tổng cộng có bao nhiêu bản sao phim trong kho?",
                "Có bao nhiêu khách hàng trong hệ thống?",
                "Có bao nhiêu giao dịch thanh toán đã được ghi nhận?",
                "Hiển thị thông tin của 5 khách hàng đầu tiên.",
                "Tìm 3 bộ phim có thời lượng dài nhất.",
                "Liệt kê các diễn viên có tên bắt đầu bằng 'J'.",
                "Tổng số tiền thanh toán trong tháng 2 năm 2007 là bao nhiêu?",
                "Khách hàng nào đã thuê nhiều phim nhất?"
            ],
            "en": [
                "How many films are in the database?",
                "List all film categories.",
                "How many inventory items are there?",
                "How many customers are in the system?",
                "How many payment transactions have been recorded?",
                "Show information for the first 5 customers.",
                "Find the 3 longest films.",
                "List actors whose names start with 'J'.",
                "What's the total payment amount in February 2007?",
                "Which customer has rented the most films?"
            ]
        }

        self.results = []

    async def run_basic_tests(self):
        """Run basic functionality tests"""
        logger.info("🧪 Starting Basic Tests...")

        # Test 1: Health Check
        logger.info("Test 1: Health Check")
        health = await self.coordinator.health_check()
        logger.info(f"Health Status: {health['overall_health']}")

        # Test 2: Simple Vietnamese query
        logger.info("Test 2: Simple Vietnamese Query")
        result = await self.coordinator.process_query("Có bao nhiêu phim?")
        logger.info(f"Success: {result['success']}")
        if result['success']:
            logger.info(f"Response: {result['response']['response']}")
            logger.info(f"SQL: {result['sql_query']}")

        # Test 3: Simple English query
        logger.info("Test 3: Simple English Query")
        result = await self.coordinator.process_query("How many customers are there?")
        logger.info(f"Success: {result['success']}")
        if result['success']:
            logger.info(f"Response: {result['response']['response']}")
            logger.info(f"SQL: {result['sql_query']}")

        logger.info("✅ Basic Tests Complete")

    async def run_comprehensive_tests(self):
        """Run comprehensive test suite"""
        logger.info("🧪 Starting Comprehensive Tests...")

        all_queries = self.test_queries["vi"] + self.test_queries["en"]

        for i, query in enumerate(all_queries, 1):
            logger.info(f"Test {i}/{len(all_queries)}: {query}")

            start_time = datetime.now()
            result = await self.coordinator.process_query(query)
            end_time = datetime.now()

            # Record result
            test_result = {
                "query": query,
                "success": result["success"],
                "response_time": (end_time - start_time).total_seconds(),
                "sql_query": result.get("sql_query", ""),
                "response": result.get("response", {}).get("response", ""),
                "error": result.get("error_message", "")
            }

            self.results.append(test_result)

            # Log result
            if result["success"]:
                logger.info(f"✅ Success - {test_result['response_time']:.2f}s")
                logger.info(f"SQL: {test_result['sql_query']}")
                logger.info(f"Response: {test_result['response'][:100]}...")
            else:
                logger.error(f"❌ Failed - {test_result['error']}")

            logger.info("-" * 80)

        logger.info("✅ Comprehensive Tests Complete")

    async def run_performance_benchmark(self):
        """Run performance benchmark"""
        logger.info("🏃 Starting Performance Benchmark...")

        # Test with different complexity levels
        benchmark_queries = [
            # Level 1: Simple COUNT
            "Có bao nhiêu phim?",
            "How many customers?",

            # Level 2: Simple SELECT
            "Liệt kê tên các thể loại phim",
            "Show all film categories",

            # Level 3: JOIN operations
            "Tìm phim và diễn viên",
            "Find films and actors",

            # Level 4: Complex queries
            "Khách hàng nào đã thuê nhiều phim nhất?",
            "Which customer rented the most films?",

            # Level 5: Aggregations
            "Tổng số tiền thanh toán theo tháng",
            "Total payment amount by month"
        ]

        performance_results = []

        for query in benchmark_queries:
            logger.info(f"Benchmarking: {query}")

            # Run multiple times for average
            times = []
            success_count = 0

            for run in range(3):  # 3 runs per query
                start_time = datetime.now()
                result = await self.coordinator.process_query(query)
                end_time = datetime.now()

                response_time = (end_time - start_time).total_seconds()
                times.append(response_time)

                if result["success"]:
                    success_count += 1

            avg_time = sum(times) / len(times)
            success_rate = success_count / 3

            performance_results.append({
                "query": query,
                "avg_response_time": avg_time,
                "success_rate": success_rate,
                "runs": times
            })

            logger.info(
                f"Avg Time: {avg_time:.2f}s, Success Rate: {success_rate*100:.1f}%")

        logger.info("✅ Performance Benchmark Complete")
        return performance_results

    def generate_report(self):
        """Generate comprehensive test report"""
        logger.info("📊 Generating Test Report...")

        if not self.results:
            logger.warning("No test results available")
            return

        # Calculate overall metrics
        total_queries = len(self.results)
        successful_queries = sum(1 for r in self.results if r["success"])
        failed_queries = total_queries - successful_queries

        accuracy = (successful_queries / total_queries) * \
            100 if total_queries > 0 else 0
        avg_response_time = sum(r["response_time"]
                                for r in self.results) / total_queries

        # Performance by language
        vi_results = [r for r in self.results if any(
            char in r["query"] for char in "àáảãạăắằẳẵặâấầẩẫậèéẻẽẹêếềểễệìíỉĩịòóỏõọôốồổỗộơớờởỡợùúủũụưứừửữự")]
        en_results = [r for r in self.results if r not in vi_results]

        vi_accuracy = (sum(
            1 for r in vi_results if r["success"]) / len(vi_results)) * 100 if vi_results else 0
        en_accuracy = (sum(
            1 for r in en_results if r["success"]) / len(en_results)) * 100 if en_results else 0

        # Create report
        report = {
            "test_summary": {
                "total_queries": total_queries,
                "successful_queries": successful_queries,
                "failed_queries": failed_queries,
                "overall_accuracy": accuracy,
                "average_response_time": avg_response_time,
                "target_accuracy": 90.0,  # Target từ paper thầy
                "meets_target": accuracy >= 90.0
            },
            "language_performance": {
                "vietnamese": {
                    "total": len(vi_results),
                    "accuracy": vi_accuracy,
                    "avg_time": sum(r["response_time"] for r in vi_results) / len(vi_results) if vi_results else 0
                },
                "english": {
                    "total": len(en_results),
                    "accuracy": en_accuracy,
                    "avg_time": sum(r["response_time"] for r in en_results) / len(en_results) if en_results else 0
                }
            },
            "detailed_results": self.results,
            "coordinator_performance": self.coordinator.get_performance_report(),
            "timestamp": datetime.now().isoformat()
        }

        # Save report
        report_filename = f"multi_agent_test_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_filename, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, ensure_ascii=False)

        # Print summary
        logger.info("📈 TEST REPORT SUMMARY")
        logger.info("=" * 50)
        logger.info(f"Total Queries: {total_queries}")
        logger.info(f"Successful: {successful_queries}")
        logger.info(f"Failed: {failed_queries}")
        logger.info(f"Overall Accuracy: {accuracy:.1f}%")
        logger.info(f"Average Response Time: {avg_response_time:.2f}s")
        logger.info(f"Target Accuracy: 90.0%")
        logger.info(f"Meets Target: {'✅ YES' if accuracy >= 90.0 else '❌ NO'}")
        logger.info("-" * 50)
        logger.info(f"Vietnamese Accuracy: {vi_accuracy:.1f}%")
        logger.info(f"English Accuracy: {en_accuracy:.1f}%")
        logger.info(f"Report saved to: {report_filename}")

        return report


async def main():
    """Main test function"""
    logger.info("🚀 Starting Multi-Agent Text-to-SQL System Test")

    tester = MultiAgentTester()

    try:
        # Run basic tests
        await tester.run_basic_tests()

        # Run comprehensive tests
        await tester.run_comprehensive_tests()

        # Run performance benchmark
        await tester.run_performance_benchmark()

        # Generate report
        report = tester.generate_report()

        logger.info("🎉 All tests completed successfully!")

    except Exception as e:
        logger.error(f"❌ Test failed: {str(e)}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
