import React from 'react';

export function Arrow({ down = false }: { down?: boolean }) {
  return (
    <svg
      className="link-arrow"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.6"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
      focusable="false"
    >
      {down ? (
        <path d="M12 4v16m-6-6 6 6 6-6" />
      ) : (
        <path d="M5 19 19 5M5 5h14v14" />
      )}
    </svg>
  );
}
