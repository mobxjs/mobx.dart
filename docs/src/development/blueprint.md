---
name: Blueprint
menu: Development Notes
route: /blueprint
---

# Blueprint (WIP)

This document outlines the core behaviors of MobX that need to be implemented for an effective reactive system.

## Core Actors

### Atom

### `Observable<T>`

- Can be observed and intercepted

### Derivation

- Depends on a set of observables to do its work.

### `Computed<T>`

- Is an observable which derives its value from a set of dependent observables
- Compare values structurally or as scalars

### Reaction

- Reactions are scheduled with a sync-scheduler or debounced with a timer-based scheduler
- They are derivations with no output value and only cause side-effects
- Handle exceptions and report them back with global handlers
- Can dispose
- Checks for convergence with 100 iterations

### Global Tracker

- Used to push pending reactions
- Determine the underlying dependencies when derivations are executed
- Keeps track of current derivation
- Keeps track of the nesting depth and use that to execute affected reactions
- Works in a transactional manner for executing pending reactions

### Action

## API

- Convenience layer to provide programmer friendly interface to the Core Actors and behaviors

### Cross cutting layers

- Memoization of computation with DependencyState
- Spying and Traceability
- Exception handling and propagation
