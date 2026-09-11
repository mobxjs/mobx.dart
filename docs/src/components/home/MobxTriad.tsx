import React, {useEffect,useRef,useState} from 'react';

function PieceIcon({kind}:{kind:'action'|'observable'|'reaction'}) {
 return <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{kind==='action'?<path d="m13 2-8 12h6l-1 8 9-13h-6l1-7Z"/>:kind==='observable'?<><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/></>:<><path d="m12 2 2.5 7.5L22 12l-7.5 2.5L12 22l-2.5-7.5L2 12l7.5-2.5L12 2Z"/></>}</svg>;
}
export function MobxTriad() {
 const [running,setRunning]=useState(false);
 const [visible,setVisible]=useState(false);
 const [count,setCount]=useState(1);
 const ref=useRef<HTMLElement>(null);
 useEffect(()=>{
   const media=matchMedia('(prefers-reduced-motion: reduce)');
   const update=()=>setRunning(!media.matches);update();media.addEventListener('change',update);
   const observer=new IntersectionObserver(([entry])=>setVisible(entry.isIntersecting),{threshold:.15});
   if(ref.current)observer.observe(ref.current);
   return()=>{media.removeEventListener('change',update);observer.disconnect();};
 },[]);
 const active=running&&visible;
 useEffect(()=>{if(!active)return;const timer=setInterval(()=>setCount(n=>n%9+1),5000);return()=>clearInterval(timer);},[active]);
 return <figure className="mobx-triad" ref={ref} aria-label="The MobX triad: actions change observable state, reactions respond. User interaction can start another action." data-running={active}>
   <div className="triad-stage">
     <div className="triad-halo"/>
     <svg className="triad-wires" viewBox="0 0 560 390" aria-hidden="true">
       <defs><marker id="orange-tip" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="5" markerHeight="5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10" fill="#e78353"/></marker><marker id="blue-tip" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="5" markerHeight="5" orient="auto-start-reverse"><path d="M0 0 10 5 0 10" fill="#5c8acb"/></marker></defs>
       <path d="M233 117 144 253" className="wire wire-action" markerEnd="url(#orange-tip)"/>
       <path d="M190 300H367" className="wire wire-state" markerEnd="url(#blue-tip)"/>
       <path d="M434 245 335 111" className="wire wire-interaction"/>
       <text x="143" y="180" transform="rotate(-57 143 180)">changes</text>
       <text x="280" y="285" textAnchor="middle">updates</text>
       <text x="419" y="165" transform="rotate(54 419 165)">user interaction</text>
       <circle className="triad-signal signal-action" r="5" fill="#e67944"/>
       <circle className="triad-signal signal-state" r="5" fill="#5589ca"/>
     </svg>
     <button className="triad-piece triad-action" onClick={()=>setCount(n=>n%9+1)} aria-label="Trigger an action in the MobX triangle"><span className="piece-icon"><PieceIcon kind="action"/></span><strong>Action</strong><code>addItem()</code></button>
     <div className="triad-center"><span>MobX</span><small>connects the dots</small></div>
     <div className="triad-piece triad-observable"><span className="piece-icon"><PieceIcon kind="observable"/></span><strong>Observable</strong><code key={count}>items = {count}</code></div>
     <div className="triad-piece triad-reaction"><span className="piece-icon"><PieceIcon kind="reaction"/></span><strong>Reaction</strong><span className="triad-ui" key={count}>Bag <b>{count}</b></span></div>
   </div>
   <figcaption><span>A little change. Everything connected.</span><button onClick={()=>setRunning(v=>!v)} aria-label={running?'Pause triangle animation':'Play triangle animation'}>{running?<svg viewBox="0 0 16 16" aria-hidden="true"><path d="M5 3v10M11 3v10" stroke="currentColor" strokeWidth="2"/></svg>:<svg viewBox="0 0 16 16" aria-hidden="true"><path d="m5 2 9 6-9 6Z" fill="currentColor"/></svg>}{running?'Pause':'Play'}</button></figcaption>
 </figure>;
}
