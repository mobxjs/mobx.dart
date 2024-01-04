import { Section } from './Section';
import { NutshellListItem } from './NutshellListItem';
import CodeBlock from '@theme/CodeBlock';
import React from 'react';
import counterSource from '!!raw-loader!../../../../mobx_examples/lib/counter/without_codegen.dart';

export function NutshellSection() {
  return (
    <Section title={'In a nutshell...'} className={'text-lg md:text-xl'}>
      <div className={'text-gray-500 mb-16 sm:columns-2'}>
        MobX is a state-management library that makes it simple to connect the
        reactive data of your application with the UI (or any observer). This
        wiring is <b>completely automatic</b> and feels very natural. As the
        application-developer, you focus purely on what reactive-data needs to
        be consumed <b>without worrying about keeping the two in sync</b>.
      </div>

      <div className={'text-center'}>
        <video
          src={'/mobx.mp4'}
          className={'text-center w-full md:w-fit'}
          muted
          autoPlay
          loop
        />
      </div>

      <div className={'grid grid-cols-1 lg:grid-cols-3 gap-4 sm:gap-8'}>
        <NutshellListItem
          title={'Observables'}
          index={1}
          detail={
            <div>
              Observables store the <b>reactive state</b> of your application.
              It will notify the associated reactions whenever the state
              changes. Observables can be simple primitives like numbers,
              strings, booleans to List, Map, Stream and Future.
            </div>
          }
        />
        <NutshellListItem
          title={'Actions'}
          index={2}
          detail={
            <div>
              Actions are responsible for <b>mutating</b> the reactive state.
              When the mutations happen, the notifications are fired
              immediately, causing all the reactions to execute. An action acts
              as an intentionally-named operation that changes the state of the
              application.
            </div>
          }
        />
        <NutshellListItem
          title={'Reactions'}
          index={3}
          detail={
            <div>
              Reactions, as the name suggests are responsible for{' '}
              <b>reacting to the state changes</b>. These can be anything from a
              simple console log, API calls to rendering the Flutter UI.
              Reaction (aka <i>"side-effect"</i>) is the only element that can
              take you out of the MobX reactivity loop.
            </div>
          }
        />
      </div>

      <CodeExample />
    </Section>
  );
}

function CodeExample() {
  return (
    <>
      <h1 className={'my-16'}>Let's see in code...</h1>
      <div className={'grid grid-cols-1 md:grid-cols-2 gap-8'}>
        <div className={'h-96 md:h-svh'}>
          <CodeBlock
            language={'dart'}
            showLineNumbers={true}
            className={'mb-8 h-full overflow-auto text-sm sm:text-base'}
            title={'Classic Counter example in MobX'}
          >
            {counterSource}
          </CodeBlock>
        </div>

        <div>
          <ul className={'list-none'}>
            <li>
              <h3>
                <StepIndicator>Step 1</StepIndicator> Observable State
              </h3>
              We first setup the observable state. In this case its a simple
              count as an integer. This forms the reactive state of our example.
            </li>
            <li className={'my-8'}>
              <h3>
                <StepIndicator>Step 2</StepIndicator> Action to mutate state
              </h3>
              Setup the action to increment the count. When the action is
              executed, it will fire notifications automatically and inform all
              associated reactions.
            </li>
            <li>
              <h3>
                <StepIndicator>Step 3</StepIndicator>
                Reaction to observe state
              </h3>
              Display the count using the <code>Observer</code>. Internally, the
              Observer is a reaction that tracks changes to the associated
              observable (count). Tracking happens automatically. The simple act
              of reading an observable value is enough. When the count changes,
              it gets notified by the action and re-renders the Flutter Widget
              to show the updated count.
            </li>
          </ul>
          This is a just a simple example to get you started.{' '}
          <a href={'/examples/counter'}>Read more</a> about building the Counter
          example, using an alternative approach, involving the{' '}
          <code>mobx_codegen</code> package.
        </div>
      </div>
    </>
  );
}

function StepIndicator({ children }: { children: React.ReactNode }) {
  return (
    <code className={'px-2 shadow-lg shadow-blue-500 bg-white text-base mr-2'}>
      {children}
    </code>
  );
}
