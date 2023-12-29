import React from 'react';

export function Section({
  children,
  className,
  containerClassName,
  title,
}: {
  children: React.ReactNode;
  className?: string;
  containerClassName?: string;
  title?: string;
}) {
  return (
    <section className={`py-16 ${className}`}>
      <div className={`container ${containerClassName}`}>
        {title && <h1>{title}</h1>}
        {children}
      </div>
    </section>
  );
}
