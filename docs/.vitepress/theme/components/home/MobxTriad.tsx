import {defineComponent,ref,computed,onMounted,onUnmounted,watch} from 'vue';
import {Zap,Eye,Sparkles,Pause,Play} from '@lucide/vue';
function PieceIcon({kind}:{kind:'action'|'observable'|'reaction'}){const Icon={action:Zap,observable:Eye,reaction:Sparkles}[kind];return <Icon size={24} stroke-width={1.7} aria-hidden="true"/>;}

export const MobxTriad=defineComponent({setup(){
 const running=ref(false), visible=ref(false), count=ref(1), element=ref<HTMLElement>();
 const stage=ref<HTMLElement>(), action=ref<HTMLElement>(), observable=ref<HTMLElement>(), reaction=ref<HTMLElement>();
 const geometry=ref({width:560,height:390,paths:['M233 130 153 236','M202 300H354','M426 233 344 130'],labels:[{x:162,y:180,anchor:'end'},{x:280,y:282,anchor:'middle'},{x:418,y:175,anchor:'start'}]});
 const updateGeometry=()=>{
  if(!stage.value||!action.value||!observable.value||!reaction.value)return;
  const bounds=stage.value.getBoundingClientRect();
  const nodes=[action.value,observable.value,reaction.value].map(node=>{const r=node.getBoundingClientRect();return {x:r.x-bounds.x+r.width/2,y:r.y-bounds.y+r.height/2,w:r.width,h:r.height};});
  const paths:string[]=[],labels:{x:number;y:number;anchor:string}[]=[];
  for(const [i,[from,to]] of [[0,1],[1,2],[2,0]].entries()){
   const a=nodes[from],b=nodes[to],dx=b.x-a.x,dy=b.y-a.y,length=Math.hypot(dx,dy),ux=dx/length,uy=dy/length;
   const source=Math.min(a.w/2/Math.abs(ux),a.h/2/Math.abs(uy))+16;
   const target=Math.min(b.w/2/Math.abs(ux),b.h/2/Math.abs(uy))+16;
   const x1=a.x+ux*source,y1=a.y+uy*source,x2=b.x-ux*target,y2=b.y-uy*target;
   paths.push('M'+x1+' '+y1+'L'+x2+' '+y2);
   labels.push({x:(x1+x2)/2+(i===0?-20:i===2?20:0),y:(y1+y2)/2+(i===1?-16:0),anchor:i===0?'end':i===2?'start':'middle'});
  }
  geometry.value={width:bounds.width,height:bounds.height,paths,labels};
 };
 const active=computed(()=>running.value&&visible.value);
 let dispose=()=>{};
 onMounted(()=>{
  const media=matchMedia('(prefers-reduced-motion: reduce)');const update=()=>running.value=!media.matches;update();media.addEventListener('change',update);
  const observer=new IntersectionObserver(([entry])=>visible.value=entry.isIntersecting,{threshold:.15});if(element.value)observer.observe(element.value);
  const sizing=new ResizeObserver(updateGeometry);for(const node of [stage.value,action.value,observable.value,reaction.value])if(node)sizing.observe(node);updateGeometry();
  dispose=()=>{media.removeEventListener('change',update);observer.disconnect();sizing.disconnect();};
 });
 onUnmounted(()=>dispose());
 watch(active,(value,_,cleanup)=>{if(!value)return;const timer=setInterval(()=>count.value=count.value%9+1,5000);cleanup(()=>clearInterval(timer));});
  return () => <figure class="mobx-triad" ref={element} aria-label="The MobX triad: actions change observable state, reactions respond. User interaction can start another action." data-running={active.value}>
   <div class="triad-stage" ref={stage}>
     <div class="triad-halo"/>
     <svg class="triad-wires" viewBox={'0 0 '+geometry.value.width+' '+geometry.value.height} aria-hidden="true">
       <defs>{['flow','return'].map(name=><marker id={'triad-'+name+'-tip'} viewBox="0 0 10 10" refX="10" refY="5" markerWidth="9" markerHeight="9" markerUnits="userSpaceOnUse" orient="auto"><path d="M0 0 10 5 0 10Z" fill={name==='flow'?'#4d86bd':'#8199b1'}/></marker>)}</defs>
       {geometry.value.paths.map((path,i)=><path d={path} class={'wire '+['wire-action','wire-state','wire-interaction'][i]} marker-end={'url(#triad-'+(i===2?'return':'flow')+'-tip)'}/>)}
       {geometry.value.labels.map((label,i)=><text x={label.x} y={label.y} text-anchor={label.anchor} dominant-baseline="middle">{['changes','updates','user interaction'][i]}</text>)}
       <circle class="triad-signal signal-action" style={{offsetPath:'path("'+geometry.value.paths[0]+'")'}} r="4" fill="#4d86bd"/>
       <circle class="triad-signal signal-state" style={{offsetPath:'path("'+geometry.value.paths[1]+'")'}} r="4" fill="#4d86bd"/>
     </svg>
     <button class="triad-piece triad-action" ref={action} onClick={()=>{count.value=count.value%9+1}} aria-label="Trigger an action in the MobX triangle"><span class="piece-icon"><PieceIcon kind="action"/></span><strong>Action</strong><code>addItem()</code></button>
     <div class="triad-center"><span>MobX</span><small>connects the dots</small></div>
     <div class="triad-piece triad-observable" ref={observable}><span class="piece-icon"><PieceIcon kind="observable"/></span><strong>Observable</strong><code key={count.value}>items = {count.value}</code></div>
     <div class="triad-piece triad-reaction" ref={reaction}><span class="piece-icon"><PieceIcon kind="reaction"/></span><strong>Reaction</strong><span class="triad-ui" key={count.value}>Bag <b>{count.value}</b></span></div>
   </div>
   <figcaption><span>A little change. Everything connected.</span><button onClick={()=>{running.value=!running.value}} aria-label={running.value?'Pause triangle animation':'Play triangle animation'}>{running.value?<Pause size={16}/>:<Play size={16}/>}
{running.value?'Pause':'Play'}</button></figcaption>
 </figure>;
}});
