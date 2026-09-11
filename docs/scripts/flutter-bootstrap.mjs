import {readFileSync,writeFileSync} from 'node:fs';

/** Keep Flutter's generated loader/build metadata; customize only its launch. */
export function finalizeFlutter(directory, base, multiView) {
  const file=directory+'/flutter_bootstrap.js';
  const source=readFileSync(file,'utf8');
  const metadata=/_flutter\.buildConfig = (\{[^\n]+\});/.exec(source);
  if(!metadata || !Array.isArray(JSON.parse(metadata[1]).builds))throw Error('Flutter bootstrap format changed');
  const launch=metadata.index+metadata[0].length;
  const config=JSON.stringify({assetBase:base,entrypointBaseUrl:base,canvasKitBaseUrl:base+'canvaskit/'});
  const chooseRenderer=`if(new URLSearchParams(location.search).get('renderer')!=='wasm')_flutter.buildConfig.builds.sort((a,b)=>Number(b.compileTarget==='dart2js')-Number(a.compileTarget==='dart2js'));`;
  const startup=multiView?`
window.mobxFlutterReady = new Promise((resolve,reject) => {
  const timeout=setTimeout(()=>reject(Error('Flutter initialization timed out')),30000);
  _flutter.loader.load({config:${config},onEntrypointLoaded:async initializer=>{
    try {const runner=await initializer.initializeEngine({...${config},multiViewEnabled:true});resolve(await runner.runApp());}
    catch(error){reject(error);}finally{clearTimeout(timeout);}
  }}).catch(error=>{clearTimeout(timeout);reject(error);});
});`:`_flutter.loader.load({config:${config}});`;
  writeFileSync(file,source.slice(0,launch)+chooseRenderer+startup);
  if(multiView){
    writeFileSync(directory+'/index.html',`<!doctype html><html lang="en"><head><meta charset="utf-8"><title>MobX gallery</title></head><body><a href="/gallery-app/index.html">Open gallery</a><script>location.replace('/gallery-app/index.html'+location.search+location.hash);</script></body></html>`);
  }else{
    writeFileSync(directory+'/index.html',`<!doctype html><html lang="en"><head><base href="${base}"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>MobX example gallery</title></head><body><script src="flutter_bootstrap.js" defer></script></body></html>`);
  }
}
