import get from 'lodash.get';

const regex = /{{\s([a-zA-Z0-9_.]*)\s}}/gm;

export function setVersions(text: string, versions: any) {
  let output = text;
  let m;

  while ((m = regex.exec(text)) !== null) {
    // This is necessary to avoid infinite loops with zero-width matches
    if (m.index === regex.lastIndex) {
      regex.lastIndex++;
    }

    output = output.replace(m[0], get(versions, m[1], 'any'));
  }
  return output;
}
