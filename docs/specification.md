# The MobX Specification

This document outlines the core behaviors of MobX that need to be implemented for an effective reactive system.

## Core Actors

### Atom

### ObservableValue<T>

### Derivation

- Depends on a set of observables to do its work.

### ComputedValue<T>

- Is an observable which derives its value from a set of dependent observables

### Reaction

- Reactions are scheduled with a sync-scheduler or debounced with a timer-based scheduler
- They are reactions with not output value and only cause side-effects

### Global Tracker

- Used to push pending reactions
- Determine the underlying dependencies when derivations are executed
- Keeps track of current derivation
- Keeps track of the nesting depth and use that to executed affected reactions

### Action

## API

- Convenience layer to provide programmer friendly interface to the Core Actors and behaviors