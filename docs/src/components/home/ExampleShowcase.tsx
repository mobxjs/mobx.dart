import React, {useState} from 'react';
import CodeBlock from '@theme/CodeBlock';
import Link from '@docusaurus/Link';
import {Arrow} from '../Arrow';
import {useMobxDemo, type DemoModel, type DemoState} from './useMobxDemo';

const examples = [
  {id:'cart', label:'Across your app', title:'One source of truth. Many happy features.', description:'Your product page, cart badge, and checkout can all read the same state. Change the quantity once. MobX keeps their derived values in sync.', file:'cart.dart', concept:'Observable + Computed + Action', link:'/api/observable', code:`final quantity = Observable(1);
final total = Computed(
  () => quantity.value * 24,
);

void addItem() => runInAction(() {
  quantity.value++;
});

// In any Flutter widget:
Observer(builder: (_) {
  return Text('\${total.value}');
});`},
  {id:'tasks',label:'Lists that stay in sync',title:'The list changes. The right things follow.',description:'Complete a task and its count updates. Turn on a filter and the list follows too. Computeds express the relationship, so you don’t maintain a second copy of the data.',file:'tasks.dart',concept:'ObservableSet + Computed',link:'/examples/todos',code:`final done = ObservableSet<String>();
final onlyPending = Observable(false);

final visible = Computed(() {
  return tasks.where((task) =>
    !onlyPending.value ||
    !done.contains(task)
  ).toList();
});

void complete(String task) {
  runInAction(() => done.add(task));
}`},
  {id:'async',label:'Async, without the juggling',title:'Loading, success, and errors. All observable.',description:'Wrap a future and react to its status. Your UI can show progress, handle an error, and display the result without keeping separate loading flags in sync.',file:'projects.dart',concept:'ObservableFuture + Observer',link:'/examples/hacker-news',code:`final request = ObservableFuture(
  fetchProjects(),
);

Observer(builder: (_) {
  return switch (request.status) {
    FutureStatus.pending => Loading(),
    FutureStatus.rejected => Retry(),
    FutureStatus.fulfilled =>
      ProjectList(request.value!),
  };
});`},
];

function Cart({state,model}:{state:DemoState;model:DemoModel}) {
 return <div className="shop-preview">
   <div className="mini-app-bar"><strong><span className="shop-mark" aria-hidden="true">✳</span> little things</strong><span className="cart-badge">Bag <b key={state.quantity}>{state.quantity}</b></span></div>
   <div className="shop-product"><div className="notebook-art" aria-hidden="true"><svg viewBox="0 0 100 120"><rect x="18" y="9" width="69" height="98" rx="5" fill="#ec784f"/><path d="M26 9v98" stroke="#a94625" strokeWidth="2"/><rect x="36" y="27" width="37" height="33" rx="2" fill="#ffe4ba"/><path d="M43 38h23M43 45h17M43 52h20" stroke="#a94625" strokeWidth="2"/><path d="M30 109h54" stroke="#d6bda1" strokeWidth="4"/></svg></div><div><span className="product-category">For your next big idea</span><h4>The everyday notebook</h4><span>$24.00</span></div></div>
   <div className="shop-quantity"><span>Make it yours</span><div className="quantity-control"><button aria-label="Remove one notebook" disabled={state.quantity===0} onClick={()=>model.changeQuantity(-1)}>−</button><output aria-label="Notebook quantity">{state.quantity}</output><button aria-label="Add one notebook" disabled={state.quantity===99} onClick={()=>model.changeQuantity(1)}>+</button></div></div>
   <div className="shipping-progress"><div className="shipping-track"><span style={{width:`${Math.min(100,state.total/72*100)}%`}}/></div><p>{state.shippingRemaining===0?'Lovely! Your shipping is on us.':`You’re $${state.shippingRemaining} away from free shipping.`}</p></div>
   <div className="shop-total"><span>Subtotal</span><output key={state.total} aria-live="polite">${state.total}.00</output></div>
   <div className="consumer-labels"><span>Product page</span><span>Cart badge</span><span>Checkout</span></div>
 </div>;
}
function Tasks({state,model}:{state:DemoState;model:DemoModel}) {
 return <div className="tasks-preview"><div className="mini-app-bar"><strong>A little progress</strong><span>{state.remaining} to go</span></div><h4>Make something lovely.</h4><label className="filter-control"><input type="checkbox" checked={state.onlyPending} onChange={e=>model.showPending(e.target.checked)}/>Show only unfinished tasks</label><div className="task-list">{state.visibleTasks.map(task=><label className={`task-row ${state.completed.includes(task)?'task-done':''}`} key={task}><input type="checkbox" checked={state.completed.includes(task)} onChange={()=>model.toggleTask(task)}/><span>{task}</span></label>)}{state.visibleTasks.length===0&&<p className="all-done">Everything’s done. Take a little bow.</p>}</div><div className="task-summary" aria-live="polite">{state.completed.length} of 3 completed<span>List and count, always in step.</span></div></div>;
}
function AsyncProjects({state,model}:{state:DemoState;model:DemoModel}) {
 const [fail,setFail]=useState(false);
 return <div className="async-preview"><div className="mini-app-bar"><strong>Your creative space</strong><span className={`request-status status-${state.requestStatus}`}>{state.requestStatus}</span></div><h4>Good things in the works.</h4><div className="projects-result" aria-live="polite">
 {state.requestStatus==='idle'&&<p>Your next projects are a click away.</p>}
 {state.requestStatus==='pending'&&<div className="loading-projects"><span/><span/><span/><p>Finding your projects…</p></div>}
 {state.requestStatus==='rejected'&&<div className="project-error"><strong>That didn’t go to plan.</strong><p>Try again. Your UI already knows what to show.</p></div>}
 {state.requestStatus==='fulfilled'&&state.projects.map((project,i)=><div className="project-row" key={project}><span className={`project-dot project-dot-${i}`}/><span>{project}</span><Arrow/></div>)}
 </div><button className="demo-primary" disabled={state.requestStatus==='pending'} onClick={()=>model.loadProjects(fail)}>{state.requestStatus==='pending'?'Loading…':state.requestStatus==='rejected'?'Try again':state.requestStatus==='fulfilled'?'Load again':'Load projects'}</button><label className="failure-control"><input type="checkbox" checked={fail} disabled={state.requestStatus==='pending'} onChange={e=>setFail(e.target.checked)}/>Try an error response</label><p className="sample-note">Example data, with a short simulated request.</p></div>;
}

export function ExampleShowcase() {
 const [selected,setSelected]=useState(0);
 const {state,model,failed,retry}=useMobxDemo();
 const example=examples[selected];
 return <section id="examples" className="example-section home-section" aria-labelledby="examples-title">
   <div className="section-heading"><h2 id="examples-title">Less keeping track.<br/><em>More making things.</em></h2><p>Small, readable pieces of Dart.<br/>Connections that keep working as your app grows.</p></div>
   <div className="example-choices" aria-label="Choose a MobX example">{examples.map((e,i)=><button key={e.id} aria-pressed={selected===i} onClick={()=>setSelected(i)}>{e.label}</button>)}</div>
   <div className="example-intro"><h3>{example.title}</h3><p>{example.description}</p></div>
   <div className="example-workbench">
     <div className="example-source"><div className="source-heading"><span>{example.file}</span><span>Dart + Flutter</span></div><CodeBlock language="dart">{example.code}</CodeBlock><div className="source-footer"><code>{example.concept}</code><Link to={example.link}>Explore <Arrow/></Link></div></div>
     <div className="example-result"><div className="result-heading"><span><i/> Live example</span><span>Give it a try</span></div>
       {!state||!model ? <div className="runtime-loading">{failed?<><p>The example couldn’t load.</p><button onClick={retry}>Try again</button></>:<p>Connecting the example…</p>}</div>:selected===0?<Cart state={state} model={model}/>:selected===1?<Tasks state={state} model={model}/>:<AsyncProjects state={state} model={model}/>}
       <div className="runtime-footnote">Powered by the MobX Dart library.</div>
     </div>
   </div>
 </section>;
}
