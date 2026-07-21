using Microsoft.AspNetCore.Mvc;
using sounak_cosmos_api.Models;
using sounak_cosmos_api.Services;

namespace sounak_cosmos_api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class testCaseController : ControllerBase
    {
        private readonly testCaseService _testCaseService;

        public testCaseController(testCaseService testCaseService)
        {
            _testCaseService = testCaseService;
        }

        // Get controller for getting all the test cases from the database
        [HttpGet("test-cases", Name = "Get All Test Cases")]
        public async Task<IActionResult> GetAll()
        {
            var testCases = await _testCaseService.GetAllAsync();

            return Ok(testCases);
        }

        // Get controller for getting a test case by id from the database
        [HttpGet("test-cases/{testcase_pid}", Name = "Get Test Case By pid")]
        public async Task<ActionResult<TestCase>> GetById(string testcase_pid)
        {
            var testCase = await _testCaseService.GetByIdAsync(testcase_pid);

            if (testCase == null)
                return NotFound(new { message = "Test case not found." });

            return Ok(testCase);
        }
    }
}
