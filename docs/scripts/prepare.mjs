import {readFileSync,writeFileSync} from 'node:fs';
import {resolve} from 'node:path';
import {codeToHtml} from 'shiki';
const docs=resolve(import.meta.dirname,'..');
const metadata=JSON.parse(readFileSync(resolve(docs,'.vitepress/theme/data/examples.json'),'utf8'));
const result=await Promise.all(metadata.map(async example=>{
  const source=readFileSync(resolve(docs,example.source??`snippets/${example.file}`),'utf8');
  const region=example.region??'snippet';
  const start=`// #region ${region}\n`,end=`// #endregion ${region}`;
  const code=source.split(start)[1]?.split(end)[0];
  if(code===undefined||!source.includes(end))throw Error(`Missing region ${region} in ${example.file}`);
  return {...example,code,html:await codeToHtml(code,{lang:'dart',themes:{light:'github-light',dark:'github-dark'},defaultColor:false})};
}));
writeFileSync(resolve(docs,'.vitepress/theme/data/generated-snippets.json'),JSON.stringify(result,null,2)+'\n');
