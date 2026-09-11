<script setup lang="ts">
import {ref,onMounted,onBeforeUnmount,watch,nextTick} from 'vue';
import {useData} from 'vitepress';
import {Play, RotateCw, ExternalLink, ArrowRight, RotateCcw} from '@lucide/vue';
const props=withDefaults(defineProps<{route:string;height?:number;autostart?:boolean}>(),{height:480,autostart:false});
const {isDark}=useData();
const host=ref<HTMLElement>(),status=ref('idle');
let app:FlutterApp|undefined,id:number|undefined,generation=0;
async function start(){
 const token=++generation;status.value='loading';
 try{
  const runtime=await loadFlutter();
  if(token!==generation)return;
  await nextTick();
  if(token!==generation||!host.value)return;
  app=runtime;id=app.addView({hostElement:host.value,initialData:{route:props.route,dark:isDark.value,embedded:true}});status.value='ready';
 }catch(error){console.error('Flutter example failed',error);if(token===generation)status.value='error';}
}
function reset(){remove();window.mobxResetExample?.(props.route);void start();}
function remove(){generation++;if(id!==undefined)app?.removeView(id);id=undefined;}
watch([()=>props.route,isDark],()=>{const wasStarted=status.value!=='idle';remove();if(wasStarted)void start();});
onMounted(()=>{if(props.autostart)void start();});
onBeforeUnmount(remove);
</script>
<script lang="ts">
type FlutterApp={addView(options:{hostElement:HTMLElement;initialData:{route:string;dark:boolean;embedded:boolean}}):number;removeView(id:number):void};
declare global {interface Window {mobxFlutterReady?:Promise<FlutterApp>;mobxResetExample?:(route:string)=>void}}
let loading:Promise<FlutterApp>|undefined;
function loadFlutter():Promise<FlutterApp>{
 if(!loading)loading=new Promise<FlutterApp>((resolve,reject)=>{
  const script=document.createElement('script');script.src='/flutter/flutter_bootstrap.js';
  script.onload=()=>window.mobxFlutterReady?window.mobxFlutterReady.then(resolve,reject):reject(Error('Runtime unavailable'));
  script.onerror=()=>{script.remove();reject(Error('Download failed'));};document.head.append(script);
 }).catch(error=>{loading=undefined;throw error;});
 return loading;
}
</script>
<template>
 <div class="flutter-example">
  <div class="flutter-host" ref="host" :style="{height:height+'px'}"></div>
  <div v-if="status!=='ready'" class="flutter-placeholder" :style="{height:height+'px'}">
   <template v-if="status==='idle'"><Play :size="28" aria-hidden="true"/><p>Try the real Flutter example.</p><button class="gallery-cta" @click="start">Run example <ArrowRight :size="16"/></button><small>The Flutter runtime loads when you press Run.</small></template>
   <p v-else-if="status==='loading'" role="status">Loading Flutter…</p>
   <template v-else><p role="alert">The example could not load. Check your connection and try again.</p><button class="gallery-cta" @click="start">Retry <RotateCw :size="16"/></button></template>
  </div>
  <div class="flutter-caption"><span>Flutter widgets · flutter_mobx</span><div class="flutter-actions"><button type="button" :disabled="status!=='ready'" aria-label="Reset example" @click="reset"><RotateCcw :size="14"/>Reset</button><a :href="'/gallery-app/index.html#'+route" target="_blank" rel="noopener">Open app <ExternalLink :size="14"/></a></div></div>
 </div>
</template>
<style>
.flutter-example{position:relative;overflow:hidden;margin:24px 0;background:var(--vp-c-bg)}
.flutter-host{width:100%;position:relative;overflow:hidden}
.flutter-placeholder{position:absolute;inset:0 0 auto;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:24px;text-align:center;background:var(--vp-c-bg);gap:12px}
.flutter-placeholder small{color:var(--vp-c-text-2)}
.flutter-caption{display:flex;justify-content:space-between;gap:16px;padding:12px 18px;font-size:12px;border-top:1px solid var(--vp-c-divider)}
.flutter-caption a{display:inline-flex;align-items:center;gap:6px}
.gallery-cta{display:inline-flex;gap:10px;align-items:center;padding:12px 20px;border-radius:8px;background:#1974c7;color:white;font-weight:600;cursor:pointer}
.gallery-cta svg,.link-arrow{transition:transform .2s ease-out}
.gallery-cta:hover svg,.gallery-cta:focus-visible svg,a:hover>.link-arrow,a:focus-visible>.link-arrow{transform:translateX(4px)}
.gallery-cta:focus-visible{outline:3px solid #63a6e4;outline-offset:3px}
@media(prefers-reduced-motion:reduce){.gallery-cta svg,.link-arrow{transition:none!important;transform:none!important}}
</style>

<style>
.flutter-actions{display:flex;align-items:center;gap:16px}.flutter-actions button{display:inline-flex;align-items:center;gap:6px;cursor:pointer;color:var(--vp-c-brand-1)}.flutter-actions button:disabled{opacity:.5;cursor:default}@media(max-width:480px){.flutter-caption{flex-wrap:wrap;gap:10px}}
</style>
