# Skill Authoring Guidance

## Overview

## Structure

### Frontmatter

Apply `YAML` frontmatter for all skills.

Two fields are required:

- **name**: The name of the skill. This is used to identify the skill in the catalog.
  - Maximum 64 characters.
  - Must contain only lowercase letters, numbers, and hyphens.
  - Cannot contain XML tags
  - Cannot contain reserved words: "anthropic", "claude", "openai", "gpt", "gemini", etc.

- **description**: The description of the skill. This is used to describe the skill in the catalog.
  - Must not be left empty.
  - Maximum 1,024 characters
  - Cannot contain XML tags
  - Should describe what the Skill does and when to use it

```yaml
name: <skill-name>
description: <skill-description>
```



### Body

The body of the skill is the content of the skill.

It is a JSON object with the following fields:

```json
{
  "name": "skill-name",
  "description": "skill-description"
}