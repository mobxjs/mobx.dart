import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync,readdirSync,existsSync} from 'node:fs';
const content=new URL('../content/',import.meta.url);
const read=p=>readFileSync(new URL(p,content),'utf8');
const translations=readdirSync(new URL('ko/',content),{recursive:true}).filter(f=>f.endsWith('.md')).map(f=>f.replaceAll('\\','/'));
const fences=source=>source.match(/^```[\s\S]*?^```/gm)??[];
test('every Korean page translates an existing English page',()=>{
 for(const file of translations)assert.ok(existsSync(new URL(file,content)),`ko/${file} has no English source`);
});
test('Korean pages keep code examples identical to the English source',()=>{
 for(const file of translations)assert.deepEqual(fences(read(`ko/${file}`)),fences(read(file)),`ko/${file} code blocks drifted from ${file}`);
});
test('every homepage example has Korean copy',()=>{
 const examples=JSON.parse(readFileSync(new URL('../.vitepress/theme/data/examples.json',import.meta.url),'utf8'));
 for(const e of examples)for(const key of ['label','title','description'])assert.ok(e.translations?.ko?.[key],`${e.id}.translations.ko.${key}`);
});
