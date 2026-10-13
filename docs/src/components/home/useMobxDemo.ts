import {useEffect, useState} from 'react';
export interface DemoState {
  quantity:number; total:number; shippingRemaining:number;
  completed:string[]; onlyPending:boolean; visibleTasks:string[]; remaining:number;
  requestStatus:'idle'|'pending'|'fulfilled'|'rejected'; projects:string[];
}
export interface DemoModel {
  changeQuantity(delta:number):void; toggleTask(task:string):void; showPending(pending:boolean):void;
  loadProjects(fail:boolean):void; dispose():void;
}
declare global {interface Window {createMobxDemo?:(listener:(snapshot:string)=>void)=>DemoModel}}
let loading:Promise<void>|undefined;
function loadRuntime() {
  if(window.createMobxDemo) return Promise.resolve();
  if(!loading) loading=new Promise<void>((resolve,reject)=>{
    const script=document.createElement('script'); script.src='/demos/mobx-demo.js'; script.async=true;
    script.onload=()=>window.createMobxDemo ? resolve() : reject(new Error('Runtime unavailable'));
    script.onerror=()=>{script.remove();reject(new Error('Runtime unavailable'));};
    document.head.append(script);
  }).catch(error=>{loading=undefined;throw error;});
  return loading;
}
export function useMobxDemo() {
  const [state,setState]=useState<DemoState|null>(null);
  const [model,setModel]=useState<DemoModel|null>(null);
  const [failed,setFailed]=useState(false);
  const [attempt,setAttempt]=useState(0);
  useEffect(()=>{
    let active=true; let instance:DemoModel|undefined;
    setFailed(false);
    loadRuntime().then(()=>{
      if(!active)return;
      instance=window.createMobxDemo!(snapshot=>{if(active)setState(JSON.parse(snapshot));});
      setModel(instance);
    }).catch(()=>{if(active)setFailed(true);});
    return()=>{active=false;instance?.dispose();};
  },[attempt]);
  return {state,model,failed,retry:()=>setAttempt(a=>a+1)};
}
