import {spawnSync} from 'node:child_process';
import {fileURLToPath} from 'node:url';
import {finalizeFlutter} from './flutter-bootstrap.mjs';
const root=fileURLToPath(new URL('../../',import.meta.url));
const flutter=process.env.FLUTTER_BIN || 'flutter';
// One app and deferred route tree, two platform roots: embeds share an engine;
// the standalone root owns browser history. Never load both for one example.
for(const [target,folder,multiView] of [['lib/site/main.dart','flutter',true],['lib/gallery/main.dart','gallery-app',false]]){
  const result=spawnSync(flutter,['build','web','--release','--wasm','--target',target,'--output','../docs/public/'+folder,'--base-href','/'+folder+'/'],{cwd:root+'mobx_examples',stdio:'inherit'});
  if(result.status!==0)process.exit(result.status??1);
  finalizeFlutter(root+'docs/public/'+folder,'/'+folder+'/',multiView);
}
