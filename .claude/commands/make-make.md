**Purpose**: Generate comprehensive Makefile with project workflow automation

---

@include shared/universal-constants.yml#Universal_Legend

## Command Execution
Execute: immediate. --plan→show plan first
Legend: Generated based on symbols used in command
Purpose: "[MAKE][Automation] Generate Makefile and scripts in $ARGUMENTS"

🔧 **MAKEFILE GENERATOR**: Analyzes your project and creates a comprehensive Makefile with shell scripts for all common developer workflows.

Carefully reviews project patterns to create automation for setup, development, testing, deployment, and maintenance tasks.

@include shared/flag-inheritance.yml#Universal_Always

Examples:
- `/make-make` - Generate Makefile and scripts for current project
- `/make-make --docker` - Include Docker-specific commands
- `/make-make --ci` - Add CI/CD pipeline commands
- `/make-make --overwrite` - Replace existing Makefile

Makefile generation workflow:
1. **Analyze project** - Review codebase for usage patterns and workflows
2. **Identify patterns** - Detect frameworks, tools, deployment methods
3. **Design commands** - Create clear, brief command names for each task
4. **Generate scripts** - Create shell scripts in `scripts/` directory
5. **Build Makefile** - Wire up make commands to execute scripts
6. **Add help** - Include comprehensive `make help` documentation

**--docker:** Include Docker build, run, and deployment commands | Container workflows
**--ci:** Add CI/CD pipeline commands for GitHub Actions/etc | Automation focus
**--env:** Include environment setup and configuration commands | Environment management
**--deploy:** Add deployment commands for various targets | Deployment automation
**--overwrite:** Replace existing Makefile without confirmation | Force regeneration
**--test-all:** Include comprehensive testing commands | Full test suite automation

⚠️ **INTELLIGENT ANALYSIS**: 
- Analyzes package.json, requirements.txt, Dockerfile, etc.
- Detects common patterns: npm/yarn, Python venv, Docker, cloud deployment
- Creates scripts that handle error cases and dependencies
- Names commands clearly and consistently

**Command execution prompt:**
```
Carefully review the common usage patterns of this project for developers, such as populating a local .env file, installing dependencies, deploying locally and remotely, and so on. Create a makefile with simple commands for all of those actions, and have the makefile execute shell scripts for each one that you should create using subagents and save to a folder called scripts/. Approach this carefully and thoroughly, and make sure each make command is named in a way that briefly and clearly indicates what it will do. Include a `make help` command that explains all of the commands.
```

**Typical Makefile commands generated:**
- `make setup` - Initial project setup (dependencies, env files, etc.)
- `make install` - Install/update dependencies
- `make dev` - Start development environment
- `make test` - Run test suite
- `make lint` - Code linting and formatting
- `make build` - Build project for production
- `make deploy` - Deploy to staging/production
- `make clean` - Clean build artifacts and temp files
- `make docker-build` - Build Docker containers
- `make docker-run` - Run in Docker locally
- `make env-setup` - Create and populate .env files
- `make db-setup` - Database initialization and migrations
- `make help` - Show all available commands with descriptions

**Generated file structure:**
```
├── Makefile                    # Main automation interface
├── scripts/                    # Shell scripts directory
│   ├── setup.sh               # Project setup script
│   ├── install.sh             # Dependency installation
│   ├── dev.sh                 # Development environment start
│   ├── test.sh                # Test execution
│   ├── lint.sh                # Linting and formatting
│   ├── build.sh               # Production build
│   ├── deploy.sh              # Deployment automation
│   ├── clean.sh               # Cleanup operations
│   ├── docker-build.sh        # Docker build script
│   ├── docker-run.sh          # Docker run script
│   ├── env-setup.sh           # Environment configuration
│   └── db-setup.sh            # Database setup
```

**Smart detection examples:**
- **Node.js projects**: npm/yarn commands, package.json scripts
- **Python projects**: pip/poetry, virtual environments, requirements
- **Docker projects**: Build, run, compose commands
- **Web frameworks**: Framework-specific dev servers and build processes
- **Database projects**: Migration, seeding, backup commands
- **Cloud deployment**: Platform-specific deploy commands

**Makefile features:**
- Clear command naming (verb-noun pattern)
- Comprehensive help documentation
- Error handling and dependency checking
- Environment variable support
- Cross-platform compatibility where possible
- Consistent script organization

**Integration with project patterns:**
- Respects existing package.json scripts
- Works with Docker Compose configurations
- Integrates with CI/CD pipeline requirements
- Supports multiple deployment targets
- Handles different development environments

@include shared/execution-patterns.yml#Git_Integration_Patterns

@include shared/universal-constants.yml#Standard_Messages_Templates

---

**🔧 WHEN TO USE**: When you want to standardize and automate common development workflows. Perfect for new projects or when you're tired of remembering complex command sequences for setup, testing, and deployment.