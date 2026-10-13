import {readFileSync,writeFileSync} from 'node:fs';
const inventory=JSON.parse(readFileSync(new URL('../api-inventory.json',import.meta.url)));
const clean = description => {
 let inCode = false;
 return description.replace(/^\s*\/\/\/? ?/gm, '').split('\n').map(line => {
  if (/^\s*```/.test(line)) {
   const opening = !inCode;
   inCode = !inCode;
   return opening && line.trim() === '```' ? line + 'dart' : line;
  }
  return inCode ? line : line.replace(/<(?=[A-Za-z/])/g, '&lt;').replace(/\{\{/g, '&#123;&#123;');
 }).join('\n');
};
for(const pkg of ['mobx','flutter_mobx','mobx_codegen','mobx_lint']){
 let out=`---\ntitle: ${pkg} public API\noutline: 2\n---\n\n# ${pkg} public API\n\nThis reference is generated from the resolved exports of \`package:${pkg}/${pkg}.dart\`, including export filters and explicitly declared public members. Inherited Dart and Flutter members follow their platform contracts. Start with the [learning path](/learn/) for guided examples, or [API families](/api/) to choose the right abstraction. Low-level exports support adapters and generated code; exporting a symbol does not make it the best starting point for an application.\n\n`;
 for(const e of inventory.filter(e=>e.package===pkg)){
  out+=`## ${e.name.replace(/=$/,' setter')}\n\nImport: \`package:${pkg}/${e.library}\`\n\n\`\`\`dart\n${e.signature}\n\`\`\`\n\n${e.description?clean(e.description):'See the [API families guide](/api/) for usage and ownership. This declaration is part of the public export surface.'}\n\n`;
  const members=[...new Map(e.members.map(m=>[m.signature,m])).values()];
  for(const m of members)out+=`### ${m.name || 'Constructor'}\n\n\`\`\`dart\n${m.signature}\n\`\`\`\n\n${m.description?clean(m.description):'Uses the enclosing type’s contract. Constructor parameters configure this instance; accessors expose its current state. For standard collection or widget overrides, the corresponding Dart or Flutter contract also applies.'}\n\n`;
 }
 writeFileSync(new URL(`../content/api/${pkg}-public.md`,import.meta.url),out);
}
console.log(`Generated references for ${inventory.length} public declarations.`);
