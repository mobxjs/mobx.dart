export function setVersions(text: string, versions: Record<string, string>) {
  return text.replace(
    /{{\s([a-zA-Z0-9_]*)\s}}/g,
    (placeholder, name: string) => versions?.[name] ?? placeholder,
  );
}
