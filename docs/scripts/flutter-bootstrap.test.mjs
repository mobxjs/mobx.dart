import test from 'node:test';
import assert from 'node:assert/strict';
import {mkdtempSync,writeFileSync,readFileSync,rmSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import vm from 'node:vm';
import {finalizeFlutter} from './flutter-bootstrap.mjs';
test('bootstrap retains metadata and launches only the selected root',async()=>{
 for(const multi of [false,true]){
  const dir=mkdtempSync(join(tmpdir(),'mobx-bootstrap-'));
  try{
   writeFileSync(join(dir,'flutter_bootstrap.js'),'_flutter.buildConfig = {"builds":[{"compileTarget":"dart2wasm"},{"compileTarget":"dart2js"}]};\n_flutter.loader.load();');
   finalizeFlutter(dir,'/fixture/',multi);finalizeFlutter(dir,'/fixture/',multi);
   let calls=0,initialization;
   const scope={URLSearchParams,location:{search:''},setTimeout,clearTimeout,window:{},_flutter:{loader:{async load(options){calls++;if(options.onEntrypointLoaded)await options.onEntrypointLoaded({async initializeEngine(config){initialization=config;return {async runApp(){return {addView(){},removeView(){}};}};}});}}}};
   vm.runInNewContext(readFileSync(join(dir,'flutter_bootstrap.js'),'utf8'),scope);
   if(multi){await scope.window.mobxFlutterReady;assert.equal(initialization.multiViewEnabled,true);assert.equal(initialization.assetBase,'/fixture/');}
   assert.equal(calls,1);assert.equal(scope._flutter.buildConfig.builds[0].compileTarget,'dart2js');
  }finally{rmSync(dir,{recursive:true,force:true});}
 }
});
