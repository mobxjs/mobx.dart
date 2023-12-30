import { Section } from './Section';
import React from 'react';
import Spline from '@splinetool/react-spline';

export function HeroSection() {
  return (
    <Section
      className={'bg-white'}
      containerClassName={
        'grid grid-cols-1 sm:grid-cols-2 gap-8 items-center justify-items-center'
      }
    >
      <div className={'order-2 sm:order-1 py-0 md:py-16 lg:py-32'}>
        <div className={'text-4xl sm:text-6xl font-extrabold'}>
          <a href={'https://github.com/mobxjs/mobx'}>MobX</a> for Dart and
          Flutter
        </div>

        <div className={'text-2xl sm:text-3xl my-4'}>
          Hassle free state-management for your Dart and Flutter apps.
        </div>

        <div className={'text-lg text-gray-500 mb-16'}>
          Use the power of <code>Observables</code>, <code>Actions</code> and{' '}
          <code>Reactions</code> to supercharge the state in your apps.
        </div>

        <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-4 text-center">
          <a
            className={`text-xl lg:text-2xl p-4 
              rounded-md sm:rounded-lg 
              shadow-xl shadow-blue-400 
              border border-solid border-white
              bg-gradient-to-br from-blue-700 to-blue-300
              hover:from-blue-900 hover:to-blue-500  
              hover:transition-colors hover:no-underline 
              text-white hover:text-white`}
            href={'/getting-started'}
          >
            Get Started 🚀
          </a>
          <a
            className={
              'text-xl lg:text-2xl p-4 rounded-md sm:rounded-lg border-blue-500 border-2 border-solid hover:no-underline hover:border-blue-600 hover:transition-colors '
            }
            href={'/concepts'}
          >
            Learn More...
          </a>
        </div>
      </div>

      <MobXLogoViewer
        className={'order-1 sm:order-2 w-full min-h-56 md:min-h-0'}
      />
    </Section>
  );
}

function MobXLogoViewer({ className }: { className?: string }) {
  return (
    <Spline
      scene="https://prod.spline.design/CB9ncfOuCZuIaUKV/scene.splinecode"
      className={className}
    />
  );
}
