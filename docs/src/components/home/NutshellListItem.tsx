import React from 'react';

export function NutshellListItem({
  title,
  detail,
  index,
}: {
  title: string;
  detail: React.ReactElement;
  index: number;
}) {
  // NOTE:
  // Have to specifically create this array to ensure the tailwindcss processor
  // does not exclude these classes
  const blue = ['bg-blue-100', 'bg-blue-200', 'bg-blue-300'];
  return (
    <aside
      className={`border border-solid border-blue-500 p-4 sm:p-8 rounded-lg ${
        blue[index - 1]
      }`}
    >
      <h2 className={'text-xl sm:text-2xl'}>
        <span
          className={
            'inline-block mr-4 rounded-lg px-4 py-2 text-lg sm:text-xl bg-blue-900 text-white'
          }
        >
          {index}
        </span>
        <span className={'text-blue-900'}>{title}</span>
      </h2>
      <div className={'text-lg sm:text-xl'}>{detail}</div>
    </aside>
  );
}
