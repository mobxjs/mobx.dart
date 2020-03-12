# Spying and Tracing

This feature adds the ability to expose the inner workings of MobX. It will report over console logs or DDT about the various activities happening inside MobX. This includes:

- When observables are read and written
- When actions are invoked
- When reactions are triggered

## Benefits

- Better visibility of MobX internals
- Better developer experience while debugging

## Implementation Strategy

Changes will be required in `mobx` and `mobx_codegen` packages. We are modeling the strategy around the way its done in **mobx.js**.

### `mobx` changes

- Create the `spy(args)` function that will be a toggle to start / stop spying. You can also pass an observable/action/reaction as argument to narrow the scope.
- A `spyReport(arg)` function is needed to report a specific activity
- Some activities like actions / reactions, are transactional and have a distinct begin-end semantics. For those we will need a `spyReportStart(arg)` and `spyReportEnd(arg)` functions.

### `mobx_codegen` changes
