# TrinityCore Project TODO

This document outlines improvements needed to make TrinityCore more accessible and easier to use for beginners, contributors, and players.

## Priority Legend

- 🔴 **Critical** - Blocks basic functionality, must be fixed
- 🟠 **High** - Significantly improves user experience
- 🟡 **Medium** - Nice to have, improves workflow
- 🟢 **Low** - Future enhancement, not urgent

## Status Legend

- ⬜ **Not Started** - Task not yet begun
- 🟦 **In Progress** - Currently being worked on
- ✅ **Completed** - Task finished
- ⏸️ **On Hold** - Temporarily paused

---

## 🎯 For Beginners (New Users)

### Installation & Setup

#### 🔴 Critical Priority

- [⬜] **Automated dependency checker script**
  - Create script that checks all required dependencies before installation
  - Provide clear error messages with installation commands for each platform
  - Check: CMake version, compiler version, MySQL, OpenSSL, Boost, etc.
  - Location: `contrib/scripts/check-dependencies.sh`

- [⬜] **Interactive setup wizard**
  - Create interactive script that guides users through initial setup
  - Ask for database credentials, paths, ports
  - Generate config files automatically
  - Validate all inputs before proceeding
  - Location: `contrib/scripts/setup-wizard.sh`

- [⬜] **Pre-configured Docker Compose for all branches**
  - Extend docker-compose.yml to support master and cata_classic branches
  - Create branch-specific compose files
  - Add environment variable support for easy configuration
  - Location: `contrib/Docker/docker-compose.*.yml`

#### 🟠 High Priority

- [⬜] **Automated TDB download and import**
  - Script that automatically downloads correct TDB version
  - Validates TDB file integrity
  - Imports TDB automatically after base database setup
  - Location: `contrib/scripts/download-tdb.sh`

- [⬜] **Game client data extraction automation**
  - Script that automates map/vmap/mmaps extraction
  - Detects game client location automatically
  - Provides progress indicators
  - Validates extracted files
  - Location: `contrib/scripts/extract-all-data.sh`

- [⬜] **One-command setup script for all platforms**
  - Single script that works on Windows, Linux, macOS
  - Detects platform automatically
  - Handles all setup steps: dependencies, database, configs, data extraction
  - Location: `contrib/scripts/setup-all.sh` / `setup-all.bat`

- [⬜] **Visual installation guide with screenshots**
  - Step-by-step guide with screenshots for each major step
  - Platform-specific visual guides
  - Common error screenshots with solutions
  - Location: `doc/installation-guides/visual/`

#### 🟡 Medium Priority

- [⬜] **Health check script**
  - Script that verifies server is running correctly
  - Checks: database connectivity, config validity, data files presence
  - Provides actionable recommendations
  - Location: `contrib/scripts/health-check.sh`

- [⬜] **Configuration file validator**
  - Tool that validates config files before server start
  - Checks for common mistakes (wrong paths, invalid ports, etc.)
  - Provides suggestions for fixes
  - Location: `contrib/tools/config-validator`

- [⬜] **Quick start templates**
  - Pre-configured templates for common scenarios (development, testing, production)
  - Different config presets for different use cases
  - Location: `contrib/templates/`

- [⬜] **Video tutorials**
  - Record video tutorials for installation on each platform
  - Cover: Docker setup, source compilation, database setup
  - Link from README and wiki

### Documentation

#### 🔴 Critical Priority

- [⬜] **Beginner-friendly README sections**
  - Add "I just want to play" quick start
  - Add "I want to develop" quick start
  - Add "I want to contribute" quick start
  - Clear separation of use cases

- [⬜] **Troubleshooting FAQ in README**
  - Expand common problems section with more examples
  - Add searchable FAQ format
  - Include error message → solution mapping

#### 🟠 High Priority

- [⬜] **Step-by-step installation checklist**
  - Printable checklist for installation
  - Checkboxes for each step
  - Platform-specific checklists
  - Location: `doc/checklists/`

- [⬜] **Common error messages database**
  - Database of common error messages with solutions
  - Searchable format
  - Links to relevant documentation
  - Location: `doc/troubleshooting/errors.md`

- [⬜] **Glossary of terms**
  - Define all technical terms used in documentation
  - Explain acronyms (TDB, DBC, vmap, mmap, etc.)
  - Location: `doc/glossary.md`

#### 🟡 Medium Priority

- [⬜] **Architecture overview for beginners**
  - High-level explanation of how TrinityCore works
  - Component diagram
  - Data flow explanation
  - Location: `doc/architecture/`

---

## 👨‍💻 For Contributors (Developers)

### Development Environment

#### 🔴 Critical Priority

- [⬜] **Development container (DevContainer)**
  - VS Code DevContainer configuration
  - Pre-configured development environment
  - All dependencies included
  - Location: `.devcontainer/`

- [⬜] **Automated code formatting**
  - Pre-commit hooks for code formatting
  - CI checks for code style
  - Auto-format on save configuration
  - Location: `.github/workflows/format-check.yml`

- [⬜] **Improved build system documentation**
  - Document all CMake options
  - Explain build types and their use cases
  - Troubleshooting build issues
  - Location: `doc/development/build-system.md`

#### 🟠 High Priority

- [⬜] **Contributor onboarding guide**
  - Step-by-step guide for new contributors
  - How to set up development environment
  - How to make first contribution
  - Code review process explanation
  - Location: `CONTRIBUTING.md` (expand)

- [⬜] **Testing framework improvements**
  - Better test documentation
  - Examples of how to write tests
  - Test coverage reporting
  - Location: `doc/development/testing.md`

- [⬜] **Code style guide with examples**
  - Expand code style documentation
  - Add examples of good vs bad code
  - Common patterns and anti-patterns
  - Location: `doc/development/code-style.md`

- [⬜] **Git workflow guide**
  - Detailed explanation of branching strategy
  - How to create proper commits
  - How to write good commit messages
  - PR creation and review process
  - Location: `doc/development/git-workflow.md`

#### 🟡 Medium Priority

- [⬜] **IDE configuration files**
  - VS Code settings and extensions
  - CLion configuration
  - Vim/Neovim setup
  - Location: `.vscode/`, `.idea/`, `.vimrc`

- [⬜] **Debugging guide**
  - How to debug worldserver/bnetserver
  - Common debugging scenarios
  - Tools and techniques
  - Location: `doc/development/debugging.md`

- [⬜] **Performance profiling guide**
  - How to profile TrinityCore
  - Tools and techniques
  - Interpreting results
  - Location: `doc/development/profiling.md`

### Code Quality

#### 🟠 High Priority

- [⬜] **Automated static analysis**
  - Integrate clang-tidy, cppcheck, or similar
  - Run in CI
  - Fix common issues automatically
  - Location: `.github/workflows/static-analysis.yml`

- [⬜] **Code documentation standards**
  - Document all public APIs
  - Add examples to complex functions
  - Generate API documentation
  - Location: `doc/api/`

- [⬜] **Unit test coverage**
  - Increase test coverage for core systems
  - Add tests for critical paths
  - Location: `tests/`

---

## 🎮 For Players (Server Administrators)

### Server Management

#### 🔴 Critical Priority

- [⬜] **Web-based admin panel**
  - Basic server management interface
  - Account management
  - Server status monitoring
  - Location: `contrib/web/admin-panel/` (separate repo?)

- [⬜] **Automated backup system**
  - Script for backing up databases
  - Configurable retention policy
  - Easy restore process
  - Location: `contrib/scripts/backup.sh`

- [⬜] **Server monitoring dashboard**
  - Real-time server statistics
  - Player count, uptime, performance metrics
  - Alert system for issues
  - Location: `contrib/monitoring/`

#### 🟠 High Priority

- [⬜] **Account creation tool**
  - Simple tool to create game accounts
  - Web interface or CLI tool
  - Location: `contrib/tools/create-account`

- [⬜] **Server configuration GUI**
  - Visual editor for server configuration
  - Validates settings
  - Explains each setting
  - Location: `contrib/tools/config-editor`

- [⬜] **Character management tools**
  - Tools for character operations (level, items, etc.)
  - Safe operations with validation
  - Location: `contrib/tools/character-manager`

- [⬜] **Update automation**
  - Script to update core and database
  - Handles conflicts
  - Backup before update
  - Location: `contrib/scripts/update-server.sh`

#### 🟡 Medium Priority

- [⬜] **Server status API**
  - REST API for server status
  - Player information
  - Server statistics
  - Location: `contrib/api/`

- [⬜] **Log analysis tools**
  - Tools to analyze server logs
  - Error detection
  - Performance analysis
  - Location: `contrib/tools/log-analyzer`

- [⬜] **Performance tuning guide**
  - Guide for optimizing server performance
  - Database tuning
  - System configuration
  - Location: `doc/administration/performance.md`

### Documentation

#### 🟠 High Priority

- [⬜] **Server administration guide**
  - Complete guide for running a server
  - Common tasks and operations
  - Best practices
  - Location: `doc/administration/`

- [⬜] **Security best practices**
  - How to secure your server
  - Firewall configuration
  - Database security
  - Location: `doc/administration/security.md`

- [⬜] **Scaling guide**
  - How to scale server for more players
  - Load balancing
  - Database optimization
  - Location: `doc/administration/scaling.md`

---

## 🔧 Infrastructure Improvements

### CI/CD

#### 🟠 High Priority

- [⬜] **Automated testing in CI**
  - Run tests on all PRs
  - Test on multiple platforms
  - Database migration tests
  - Location: `.github/workflows/`

- [⬜] **Automated Docker image building**
  - Build and push Docker images on releases
  - Multi-arch support
  - Location: `.github/workflows/docker-build.yml`

- [⬜] **Automated documentation generation**
  - Generate API docs from code
  - Update wiki automatically
  - Location: `.github/workflows/docs.yml`

### Tooling

#### 🟡 Medium Priority

- [⬜] **Database migration tool**
  - Tool to apply database updates automatically
  - Handles conflicts
  - Rollback capability
  - Location: `contrib/tools/db-migrate`

- [⬜] **Config migration tool**
  - Tool to update config files when format changes
  - Preserves user settings
  - Location: `contrib/tools/config-migrate`

- [⬜] **Release automation**
  - Automated release process
  - Changelog generation
  - Tag creation
  - Location: `.github/workflows/release.yml`

---

## 📚 Documentation Improvements

### General

#### 🔴 Critical Priority

- [⬜] **Consolidate documentation**
  - Ensure all docs are up to date
  - Remove outdated information
  - Single source of truth
  - Location: `doc/`

- [⬜] **Documentation search**
  - Make documentation searchable
  - Add search to wiki
  - Index all markdown files

#### 🟠 High Priority

- [⬜] **Translation support**
  - Support for multiple languages
  - Community translations
  - Location: `doc/i18n/`

- [⬜] **Interactive tutorials**
  - Step-by-step interactive guides
  - Progress tracking
  - Location: `doc/tutorials/`

- [⬜] **API reference**
  - Complete API documentation
  - Examples for each API
  - Location: `doc/api/`

---

## 🐛 Bug Fixes & Improvements

### Known Issues

#### 🔴 Critical Priority

- [⬜] **Improve error messages**
  - Make error messages more descriptive
  - Include solutions in error messages
  - Better logging

- [⬜] **Database connection resilience**
  - Better handling of database connection issues
  - Automatic reconnection
  - Clear error messages

#### 🟠 High Priority

- [⬜] **Configuration validation on startup**
  - Validate all configs before starting
  - Clear error messages for invalid configs
  - Suggestions for fixes

- [⬜] **Better logging**
  - Structured logging
  - Log levels configuration
  - Log rotation

---

## 📊 Metrics & Monitoring

### Analytics

#### 🟡 Medium Priority

- [⬜] **Usage analytics (opt-in)**
  - Track common configurations
  - Identify pain points
  - Improve based on data

- [⬜] **Performance benchmarks**
  - Regular performance testing
  - Track regressions
  - Location: `contrib/benchmarks/`

---

## 🎯 Quick Wins (Easy to implement, high impact)

- [⬜] Add more examples to README
- [⬜] Create troubleshooting flowchart
- [⬜] Add "Getting Help" section to all major docs
- [⬜] Create FAQ from common forum questions
- [⬜] Add badges to README (license, version, etc.)
- [⬜] Create issue templates for different types
- [⬜] Add code examples to documentation
- [⬜] Create comparison table (Docker vs Source)
- [⬜] Add estimated time for each installation method
- [⬜] Create "First 5 minutes" guide

---

## 📝 Notes

- This TODO is a living document and should be updated regularly
- Priorities may change based on community feedback
- Some items may require discussion before implementation
- Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 🤝 How to Contribute

If you want to work on any of these items:

1. Check if someone is already working on it (search issues/PRs)
2. Comment on the item or create an issue to claim it
3. Follow the contribution guidelines in [CONTRIBUTING.md](CONTRIBUTING.md)
4. Submit a PR when ready

---

**Last Updated**: 2024-11-25
**Maintained by**: TrinityCore Community
