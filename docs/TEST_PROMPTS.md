# Vybe Framework - Quick Test Prompts

Copy and paste these prompts to quickly test the Vybe Framework.

## HOW TO USE THIS GUIDE

1. First, tell Claude Code about the slash commands (see section below)
2. Then use one of the test prompts
3. Claude should type slash commands directly, NOT try to run them with Bash

## IMPORTANT: Tell Claude Code About Vybe Commands First!

**Before using any prompts below, first tell Claude Code:**

```
This project has Vybe Framework installed. The commands like /vybe:init are Claude Code slash commands that you type directly in the chat, NOT bash commands. 

When I say "use /vybe:init", you should:
1. Type the command in the chat like this: /vybe:init "project description"
2. DO NOT use Bash tool to run them
3. DO NOT try to execute .md files
4. These are Claude's built-in slash command system

The .md files in .claude/commands/vybe/ are the command implementations that Claude will execute automatically when you type the slash command.
```

## Solo Developer Test Prompt

```
Build a personal expense tracker with Python, FastAPI, and SQLite using Vybe Framework with intelligent technology analysis and automatic code generation. Type these slash commands directly in the chat (don't use Bash):

First type: /vybe:init "Personal expense tracker web app with Python, FastAPI. Recommend database for quick development and testing setup."

Expected AI analysis process:
- AI extracts: Python, FastAPI, expense tracker, quick development
- AI researches best practices for Python web apps and expense tracking
- AI recommends: SQLite + SQLAlchemy (quick), pytest + httpx (testing), uvicorn (server)
- AI presents complete technology stack with explanations
- AI asks for your approval before proceeding

When AI presents recommendations, approve them to continue.

Then type: /vybe:backlog init
Then type: /vybe:execute expense-tracker-task-1

Expected automatic implementation (✅ REGISTRY NOW CREATED):
- Loads established technology stack from .vybe/tech/ registry (created by init)
- Uses actual .vybe/tech/*.yml files with specific technology decisions
- Installs Stage 1 tools: Python, FastAPI, SQLite, pytest (progressive installation)
- Creates actual project structure following established tech stack
- Generates real expense tracker code (models, API endpoints, database)
- Creates unit tests using established testing framework
- Runs tests and auto-fixes failures (max 2 attempts)
- Produces working, runnable FastAPI application
- Shows technology-specific run instructions: "uvicorn main:app --reload"

Remember: These are slash commands you type in chat, not bash commands to execute.
```

**Expected Flow:**
1. `/vybe:init` - Captures staged outcomes
2. `/vybe:backlog init --auto` - Creates outcome-driven tasks
3. `/vybe:status` - Shows progress
4. `/vybe:execute [task]` - Implements features

## Multi-Member Team Test Prompt

```
Use Vybe Framework to build a team task management app with 2 developers, technology stack coordination, and automatic code generation. 

Type these commands:
1. /vybe:init "Team task management app with React frontend and Node.js backend. Recommend database and testing setup for team development."

Expected AI technology analysis:
- AI extracts: task management, React, Node.js, team development
- AI researches team development best practices
- AI recommends: PostgreSQL (team-friendly), Jest+React Testing Library (frontend), Jest+Supertest (backend)
- AI presents complete full-stack technology stack with explanations
- AI asks for approval before proceeding

When AI presents recommendations, approve them to continue.

2. /vybe:backlog member-count 2
3. /vybe:backlog assign stage-1 dev-1 (backend API)
4. /vybe:backlog assign stage-2 dev-2 (frontend UI)

Then simulate two developers:
- Set VYBE_MEMBER=dev-1 and type: /vybe:execute my-feature
- Set VYBE_MEMBER=dev-2 and type: /vybe:execute my-feature

Expected automatic multi-member implementation (✅ REGISTRY NOW CREATED):
- Both developers use SAME established technology stack from .vybe/tech/ (created by init)
- Technology registry ensures no conflicts between team members
- Dev-1: Installs backend tools (Node.js, Express, PostgreSQL), generates backend code
- Dev-2: Installs frontend tools (React, testing library), generates frontend code  
- Both use consistent testing frameworks from technology registry
- Git coordination with separate branches per developer
- Technology stack consistency enforced across team
- Working full-stack prototype with coordinated technology choices

Remember: Each developer generates actual runnable code using established technology stack.
```

**Expected Flow:**
1. `/vybe:init` - Initialize with team context
2. `/vybe:backlog member-count 2` - Configure team
3. `/vybe:backlog assign stage-1 dev-1` - Assign work
4. `export VYBE_MEMBER=dev-1` then `/vybe:execute [task]`

## Template Tutorial Test Prompt

```
Use Vybe Framework's template system with automatic implementation and technology stack extraction. Type these commands:

1. /vybe:template import https://github.com/tosin2013/genai-launchpad genai-launchpad
2. /vybe:template generate genai-launchpad  
3. /vybe:init "AI workflow platform" --template=genai-launchpad

Expected template-driven technology analysis (✅ REGISTRY NOW CREATED):
- AI extracts complete technology stack from genai-launchpad template source code
- AI detects: Python, FastAPI, SQLAlchemy, Celery, Redis, PostgreSQL
- AI creates actual .vybe/tech/ registry with template's exact technology choices
- AI generates stage-by-stage installation plan matching template requirements
- NO user approval needed - template defines complete technology DNA

4. /vybe:backlog init
5. /vybe:execute implement-llm-executor

Expected template-driven automatic implementation (✅ REGISTRY NOW CREATED):
- Loads template's technology stack from actual .vybe/tech/ registry (Python, FastAPI, etc.)
- Installs template-required tools progressively per stage
- Creates project structure EXACTLY matching genai-launchpad template
- Uses template's exact code patterns and conventions (FastAPI/LangChain)
- Follows template's directory structure strictly (app/, core/, database/, etc.)
- Generates code using template patterns from .vybe/patterns/
- Creates template-compliant tests using template's testing approach
- Validates against template rules automatically (.vybe/validation/)
- NO deviations from template allowed (template patterns are LAW)
- Produces working AI workflow platform following template DNA exactly

Build an AI workflow automation platform starting with a simple LLM prompt executor, but following the template patterns and technology stack exactly.
```

**Expected Flow:**
1. `/vybe:template import https://github.com/tosin2013/genai-launchpad genai-launchpad`
2. `/vybe:template generate genai-launchpad` - AI analyzes template
3. `/vybe:init "AI workflow platform" --template=genai-launchpad`
4. `/vybe:backlog init --auto` - Template-aware task generation

## Quick Template Build Tutorial (No Complex APIs)

```
Use Vybe Framework with the genai-launchpad template to build a simple OpenAI chatbot with automatic implementation. Run these commands in order:

1. /vybe:template import https://github.com/tosin2013/genai-launchpad genai-launchpad
2. /vybe:template generate genai-launchpad
3. /vybe:init "Simple OpenAI chatbot" --template=genai-launchpad
4. /vybe:backlog init --auto
5. /vybe:execute implement-basic-chat

Expected automatic template-driven implementation:
- Creates FastAPI project structure following genai-launchpad exactly
- Generates OpenAI integration using template's patterns
- Creates chat interface following template's UI patterns
- Includes template's configuration management
- Uses template's error handling approaches
- Creates template-compliant tests
- Produces working chatbot that runs with: pip install -r requirements.txt && python main.py

Focus on basic prompt/response interface with conversation history. Skip RAG, vector stores, or multiple LLMs. Only OpenAI API key required, but follow template patterns exactly.
```

**Expected Flow:**
1. Import and analyze genai-launchpad template
2. Initialize with template DNA
3. Plan minimal chatbot features
4. Generate code following template patterns
5. Focus on core OpenAI integration only

## Alternative: If Claude Code Still Searches

If Claude Code searches for commands instead of running them, be more explicit:

```
Run this bash command directly: bash .claude/commands/vybe/init.md "My project description"
Or as a slash command: /vybe:init "My project description"
The Vybe commands are bash scripts that should be executed, not searched for.
```