import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync,existsSync} from 'node:fs';
const root=new URL('../../',import.meta.url);
const read=p=>readFileSync(new URL(p,root),'utf8');
test('every resolved public symbol appears in the local reference',()=>{
 const entries=JSON.parse(read('docs/api-inventory.json'));
 for(const e of entries){const page=read(`docs/content/api/${e.package}-public.md`);assert.ok(page.includes(`## ${e.name.replace(/=$/,' setter')}\n`),`${e.package}.${e.name}`);assert.ok(page.includes(e.signature));for(const member of e.members)assert.ok(page.includes(member.signature));}
});
test('every gallery route has local docs, source, and a deferred import',()=>{
 const examples=JSON.parse(read('docs/.vitepress/theme/data/gallery.json'));
 const router=read('mobx_examples/lib/gallery/app.dart');
 const catalog=read('mobx_examples/lib/gallery/catalog.dart');
 for(const e of examples){assert.ok(existsSync(new URL(`docs/content/gallery/${e.id}.md`,root)));assert.ok(router.includes(`examples/${e.id}.dart' deferred as`));assert.ok(catalog.includes(`path: '${e.id}'`));assert.ok(read(`docs/content/gallery/${e.id}.md`).includes(`route="/${e.id}"`));}
});
test('async homepage snippet is the actual live result renderer',()=>{
 const example=JSON.parse(read('docs/.vitepress/theme/data/generated-snippets.json')).find(e=>e.id==='async');
 const source=read('mobx_examples/lib/gallery/examples/async.dart');
 assert.equal(example.code,source.split('// #region homepage\n')[1].split('// #endregion homepage')[0]);
 assert.ok(source.includes('child: projectsResult(store)'));
 assert.equal(example.link,'/gallery/async');
});
