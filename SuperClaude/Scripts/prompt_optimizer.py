#!/usr/bin/env python3
"""
Prompt Optimizer for Claude Code
Transforms casual user requests into scaffolded, optimized prompts
"""

import sys
import os
import json
import re
from pathlib import Path
from typing import Dict, List, Optional, Tuple

class PromptOptimizer:
    def __init__(self):
        self.context = self._gather_context()

    def _gather_context(self) -> Dict:
        """Gather project context for enrichment"""
        context = {
            'cwd': os.getcwd(),
            'files': [],
            'framework': None,
            'language': None,
            'has_tests': False,
            'has_git': os.path.exists('.git')
        }

        # Detect project type
        if os.path.exists('package.json'):
            context['framework'] = 'Node.js/JavaScript'
            context['language'] = 'JavaScript/TypeScript'
            context['has_tests'] = os.path.exists('test') or os.path.exists('tests') or os.path.exists('__tests__')
        elif os.path.exists('requirements.txt') or os.path.exists('pyproject.toml'):
            context['framework'] = 'Python'
            context['language'] = 'Python'
            context['has_tests'] = os.path.exists('tests') or os.path.exists('test')
        elif os.path.exists('Cargo.toml'):
            context['framework'] = 'Rust'
            context['language'] = 'Rust'
        elif os.path.exists('go.mod'):
            context['framework'] = 'Go'
            context['language'] = 'Go'

        # Get recent files in current directory
        try:
            for item in os.listdir('.')[:10]:
                if os.path.isfile(item) and not item.startswith('.'):
                    context['files'].append(item)
        except:
            pass

        return context

    def classify_request(self, request: str) -> str:
        """Classify the type of request"""
        request_lower = request.lower()

        # Feature implementation
        if any(word in request_lower for word in ['add', 'create', 'implement', 'build', 'make']):
            return 'feature'

        # Bug fixing
        elif any(word in request_lower for word in ['fix', 'bug', 'error', 'broken', 'crash']):
            return 'bugfix'

        # Performance
        elif any(word in request_lower for word in ['slow', 'performance', 'optimize', 'speed']):
            return 'performance'

        # Refactoring
        elif any(word in request_lower for word in ['refactor', 'clean', 'improve', 'reorganize']):
            return 'refactor'

        # Testing
        elif any(word in request_lower for word in ['test', 'testing', 'coverage']):
            return 'testing'

        # Documentation
        elif any(word in request_lower for word in ['document', 'docs', 'readme', 'comment']):
            return 'documentation'

        # Analysis
        elif any(word in request_lower for word in ['why', 'analyze', 'understand', 'explain']):
            return 'analysis'

        else:
            return 'general'

    def scaffold_prompt(self, request: str, request_type: str) -> str:
        """Create scaffolded prompt based on request type"""

        # Base context
        context_info = []
        if self.context['framework']:
            context_info.append(f"Project type: {self.context['framework']}")
        if self.context['language']:
            context_info.append(f"Language: {self.context['language']}")
        if self.context['files']:
            context_info.append(f"Project contains: {', '.join(self.context['files'][:5])}")

        context_str = '\n'.join(context_info) if context_info else "Working in current directory"

        # Build scaffolded prompt based on type
        if request_type == 'feature':
            return self._scaffold_feature(request, context_str)
        elif request_type == 'bugfix':
            return self._scaffold_bugfix(request, context_str)
        elif request_type == 'performance':
            return self._scaffold_performance(request, context_str)
        elif request_type == 'refactor':
            return self._scaffold_refactor(request, context_str)
        elif request_type == 'testing':
            return self._scaffold_testing(request, context_str)
        elif request_type == 'documentation':
            return self._scaffold_documentation(request, context_str)
        elif request_type == 'analysis':
            return self._scaffold_analysis(request, context_str)
        else:
            return self._scaffold_general(request, context_str)

    def _scaffold_feature(self, request: str, context: str) -> str:
        return f"""<context>
{context}
User request: {request}
</context>

<objective>
Implement the requested feature with production-ready code
</objective>

<constraints>
- Follow existing code patterns and conventions
- Include proper error handling
- Ensure backward compatibility
- Add appropriate validation
- Consider edge cases
- Maintain code quality standards
</constraints>

<steps>
1. Analyze existing code structure and patterns
2. Design the feature implementation approach
3. Implement core functionality with error handling
4. Add input validation and edge case handling
5. Create or update tests for the new feature
6. Update documentation and code comments
7. Verify integration with existing features
8. Run linting and formatting tools
</steps>

<validation>
✓ Feature works as requested
✓ All tests pass
✓ No breaking changes introduced
✓ Code follows project conventions
✓ Documentation updated
✓ Error handling implemented
</validation>"""

    def _scaffold_bugfix(self, request: str, context: str) -> str:
        return f"""<context>
{context}
Issue reported: {request}
</context>

<objective>
Identify and fix the reported issue while preventing regression
</objective>

<constraints>
- Preserve existing functionality
- Fix root cause, not just symptoms
- Add tests to prevent regression
- Document the fix
- Maintain backward compatibility
</constraints>

<steps>
1. Reproduce the issue to confirm the problem
2. Investigate root cause using debugging tools
3. Review recent changes that might have caused the issue
4. Implement fix addressing the root cause
5. Add tests to prevent regression
6. Verify fix doesn't break other functionality
7. Document the issue and solution
8. Clean up any debugging code
</steps>

<validation>
✓ Issue no longer reproducible
✓ Root cause identified and fixed
✓ Tests added to prevent regression
✓ No new issues introduced
✓ All existing tests still pass
</validation>"""

    def _scaffold_performance(self, request: str, context: str) -> str:
        return f"""<context>
{context}
Performance concern: {request}
</context>

<objective>
Identify and resolve performance bottlenecks with measurable improvements
</objective>

<constraints>
- Measure before optimizing
- Preserve functionality
- Document performance gains
- Focus on biggest impact first
- Avoid premature optimization
</constraints>

<steps>
1. Profile current performance to establish baseline
2. Identify performance bottlenecks with metrics
3. Analyze code for:
   - Inefficient algorithms (O(n²) or worse)
   - Unnecessary iterations or computations
   - Memory leaks or excessive allocations
   - Blocking I/O operations
   - Missing caching opportunities
4. Implement optimizations for biggest bottlenecks
5. Measure improvement after each change
6. Add performance tests/benchmarks
7. Document optimizations and trade-offs
8. Set up monitoring for future regression
</steps>

<validation>
✓ Performance metrics documented before/after
✓ Measurable improvement achieved
✓ No functionality broken
✓ Optimizations documented
✓ Performance tests added
</validation>"""

    def _scaffold_refactor(self, request: str, context: str) -> str:
        return f"""<context>
{context}
Refactoring request: {request}
</context>

<objective>
Improve code quality and maintainability without changing functionality
</objective>

<constraints>
- Preserve all existing functionality
- Maintain backward compatibility
- Keep tests passing throughout
- Follow project style guide
- Document significant changes
</constraints>

<steps>
1. Run existing tests to establish baseline
2. Identify refactoring opportunities:
   - Duplicate code elimination (DRY)
   - Complex method extraction
   - Better naming and clarity
   - Design pattern application
   - Dependency reduction
3. Refactor incrementally with test verification
4. Improve code organization and structure
5. Add missing type hints/annotations
6. Update documentation and comments
7. Run linting and formatting
8. Verify performance hasn't degraded
</steps>

<validation>
✓ All tests still passing
✓ Code complexity reduced
✓ No functionality changed
✓ Code more maintainable
✓ Documentation updated
</validation>"""

    def _scaffold_testing(self, request: str, context: str) -> str:
        return f"""<context>
{context}
Testing request: {request}
</context>

<objective>
Create comprehensive tests to ensure code quality and prevent regressions
</objective>

<constraints>
- Cover happy path and edge cases
- Include error scenarios
- Maintain test readability
- Follow testing best practices
- Ensure tests are maintainable
</constraints>

<steps>
1. Analyze code to identify test requirements
2. Set up test fixtures and utilities
3. Write unit tests for individual functions/methods
4. Add integration tests for component interactions
5. Include edge cases and error scenarios
6. Test boundary conditions and limits
7. Add performance tests if applicable
8. Ensure adequate code coverage (aim for >80%)
9. Document test scenarios and purposes
10. Verify all tests pass consistently
</steps>

<validation>
✓ Code coverage >80%
✓ All critical paths tested
✓ Edge cases covered
✓ Tests are maintainable
✓ Tests run quickly
✓ Clear test documentation
</validation>"""

    def _scaffold_documentation(self, request: str, context: str) -> str:
        return f"""<context>
{context}
Documentation request: {request}
</context>

<objective>
Create clear, comprehensive documentation for developers and users
</objective>

<constraints>
- Use clear, concise language
- Include practical examples
- Cover common use cases
- Maintain consistency
- Keep documentation current
</constraints>

<steps>
1. Analyze code structure and functionality
2. Document:
   - Purpose and overview
   - Installation/setup instructions
   - API reference with parameters
   - Usage examples and patterns
   - Configuration options
   - Troubleshooting guide
   - Contributing guidelines
3. Add inline code comments for complex logic
4. Create or update README file
5. Add docstrings/JSDoc comments
6. Include diagrams if helpful
7. Verify documentation accuracy
8. Check for completeness and clarity
</steps>

<validation>
✓ All public APIs documented
✓ Examples are working
✓ Documentation is clear
✓ No outdated information
✓ Consistent formatting
</validation>"""

    def _scaffold_analysis(self, request: str, context: str) -> str:
        return f"""<context>
{context}
Analysis request: {request}
</context>

<objective>
Provide thorough analysis with clear insights and actionable findings
</objective>

<constraints>
- Base analysis on evidence
- Be thorough but focused
- Provide clear conclusions
- Include supporting data
- Suggest next steps
</constraints>

<steps>
1. Understand the specific question or concern
2. Gather relevant data and context
3. Analyze code/system for:
   - Current implementation details
   - Design patterns and architecture
   - Dependencies and interactions
   - Performance characteristics
   - Potential issues or risks
4. Identify root causes and relationships
5. Document findings with evidence
6. Provide clear conclusions
7. Suggest actionable recommendations
8. Include relevant metrics or examples
</steps>

<validation>
✓ Question fully answered
✓ Analysis based on evidence
✓ Clear conclusions provided
✓ Actionable insights included
✓ Supporting data documented
</validation>"""

    def _scaffold_general(self, request: str, context: str) -> str:
        return f"""<context>
{context}
Request: {request}
</context>

<objective>
Complete the requested task efficiently and correctly
</objective>

<constraints>
- Follow best practices
- Maintain code quality
- Document changes
- Consider edge cases
- Ensure reliability
</constraints>

<steps>
1. Understand the full scope of the request
2. Plan the implementation approach
3. Execute the task systematically
4. Validate the results
5. Document what was done
6. Verify quality standards met
</steps>

<validation>
✓ Request completed successfully
✓ Quality standards met
✓ Changes documented
✓ No issues introduced
</validation>"""

    def optimize(self, user_request: str) -> Tuple[str, str]:
        """Main optimization function"""
        request_type = self.classify_request(user_request)
        scaffolded = self.scaffold_prompt(user_request, request_type)
        return request_type, scaffolded

def main():
    if len(sys.argv) < 2:
        print("Usage: prompt_optimizer.py '<request>'")
        sys.exit(1)

    user_request = ' '.join(sys.argv[1:])
    optimizer = PromptOptimizer()
    request_type, scaffolded = optimizer.optimize(user_request)

    # Output format for Claude Code to process
    output = {
        'original': user_request,
        'type': request_type,
        'scaffolded': scaffolded
    }

    print("=== ORIGINAL REQUEST ===")
    print(user_request)
    print("\n=== REQUEST TYPE DETECTED ===")
    print(request_type)
    print("\n=== SCAFFOLDED PROMPT (EXECUTING) ===")
    print(scaffolded)
    print("\n=== EXECUTING NOW ===")

if __name__ == "__main__":
    main()