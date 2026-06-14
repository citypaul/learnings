# Learnings

This repo is the place where project work turns into durable lessons.

When a concept shows up in a real project, we capture it here with the `teach-me` skill: grounded in the code that caused the question, backed by trusted sources, and shaped for later retrieval practice. The point is not to collect notes for their own sake. The point is to make future Paul faster, calmer, and more accurate when the same idea appears again under pressure.

## Philosophy

Learning here is evidence-led. A lesson should name the project, files, commands, decisions, and failures that made the concept matter. It should also cite primary sources when the topic can drift: official docs for cloud platforms, framework docs for libraries, papers or books for stable theory.

Learning here is retrieval-led. Reading a page is exposure, not mastery. A captured lesson is useful because it gives tomorrow's tutor something precise to ask about. Mastery only gets recorded after you can explain, apply, compare, or debug the concept without the answer in front of you.

Learning here is project-shaped. We do not learn "AWS" in the abstract when the actual lesson was "how GitHub Actions exchanges an OIDC token for short-lived AWS credentials, and why the IAM trust policy failed." The closer the artifact stays to the real work, the more likely it is to transfer back into real work.

Learning here is cumulative. Each topic gets one workspace under `learning/`, with a plan, sources, session log, cheat sheet, and self-contained HTML lessons. The HTML files are designed to be revisited offline, printed, or opened quickly before the next pairing session.

## Structure

```text
learning/
  topic-slug/
    plan.md
    resources.md
    glossary.md
    cheat-sheet.md
    session-log.md
    lessons/
      0001-topic.html
      0002-next-topic.html
```

## Capture Mode

Sometimes there is no time for a full interactive lesson. In that case we use capture mode:

- produce the HTML lesson up front;
- mark the session as captured, not taught;
- avoid adding learning records for mere exposure;
- start the next live session with spaced review questions from the captured material.

That small distinction matters. It keeps the repo useful without lying to the learning system.

## What Good Looks Like

A good learning artifact is short enough to revisit, specific enough to be useful, and opinionated enough to reflect what the project actually chose. It should make the next conversation easier: the tutor can ask better questions, and the learner can retrieve the real lesson instead of re-opening ten tabs and a commit history.
